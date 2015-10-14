class InnerScreen < BaseUI

  def has_text(text)
    wait { text_exact text }
  end

end