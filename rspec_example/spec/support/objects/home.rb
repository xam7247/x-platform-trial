class Home < BaseUI

  def first_cell
    @found_cell = wait { text 2 }
    self
  end

  def title
    @found_cell.name.split(',').first
  end

  def click
    @found_cell.click
  end

end