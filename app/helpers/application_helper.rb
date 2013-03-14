module ApplicationHelper
  def favicon
    raw %q{<link rel="icon" href="/favicon.ico" type="image/x-icon" />} +
        %q{<link rel="icon" href="/favicon.png" type="image/png" />}
  end
end
