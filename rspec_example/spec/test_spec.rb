describe 'Sample tests', :type => :feature do

  it "Tests cross platform execution" do
    cell_title = @app.home.first_cell.title
    @app.home.first_cell.click
    @app.inner_screen.has_text cell_title
  end

  it "Tests combination platform execution", :combo do
    cell_title = @app.home.first_cell.title
    @app.home.first_cell.click
    sleep 5
    visit("/")
    sleep 5
    @app.inner_screen.has_text cell_title
  end

end
