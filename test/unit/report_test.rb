require 'test_helper'

class ReportTest < ActiveSupport::TestCase

  def setup
    @html = <<-eos
<TABLE  class="sortable" border="1" cellspacing="1" cellpadding="2" id="dash">
<TR>
<TH>Transaction_Date</TH>
<TH>Location</TH>
<TH>Amount</TH>
</TR>
<TR>
<TD>2012-02-10 Fri 01:17:22PM</TD>
<TD>DDS - Courtyard Cafe</TD>
<TD>         -$4.22</TD>
</TR>
</TABLE>
eos
  end

  test "should normalize locations" do
    report = Report.new
    assert_equal("King Arthur Flour Cafe", report.normalize_location("King Arthur Flour Coffee Bar at Baker Library"))
    assert_equal("King Arthur Flour Cafe", report.normalize_location("King Arthur Flour Coffee Bar"))

    assert_equal("Courtyard Cafe", report.normalize_location("Courtyard Cafe"))
    assert_equal("Courtyard Cafe", report.normalize_location("DDS - Courtyard Cafe"))

    assert_equal("Novack Cafe", report.normalize_location("Novack Cafe"))
    assert_equal("Novack Cafe", report.normalize_location("Novack Cafe"))

    assert_raise(RuntimeError) { report.normalize_location("Molly's") }
  end

  test "should parse banner html" do
    report = users(:bob).reports.create(:html => @html,
                              :source => "banner")

    report.parse

    purchase = users(:bob).purchases.first
    assert_equal("Courtyard Cafe", purchase.location)
    assert_equal(4.22, purchase.amount)
    assert_equal(DateTime.new("2012-02-10 Fri 01:17:22PM"), purchase.time)
  end
end