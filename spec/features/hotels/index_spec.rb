require "rails_helper"

feature "List Articles" do
  let!(:first_hotel) do
    create :hotel, name: "Гостиничный комплекс Татарстан", address: "г. Казань, ул. Пушкина, 4",
                   longitude: 49.12240500000007, latitude: 55.786463, rating: 7.4, stars: 3
  end
  let!(:second_hotel) do
    create :hotel, name: "Отель НОГАЙ", address: "г. Казань, ул. Профсоюзная улица, 16Б",
                   longitude: 49.11462860000006, latitude: 55.7919311, rating: 9.1, stars: 3
  end

  let(:hotel_selector) { ".hotel-item" }
  let(:first_hotel_selector) { ".hotel-item[data-id='#{first_hotel.id}']" }
  let(:second_hotel_selector) { ".hotel-item[data-id='#{second_hotel.id}']" }

  scenario "Visitor sees list of hotels" do
    visit hotels_path

    expect(page).to have_content("Hotels")
    expect(page).to have_selector(hotel_selector, count: 2)

    within first_hotel_selector do
      expect(page).to have_content("Гостиничный комплекс Татарстан")
      expect(page).to have_content("Address: г. Казань, ул. Пушкина, 4")
      expect(page).to have_content("Stars: 3")
      expect(page).to have_content("Rating: 7.4")
      expect(page).to have_content("Distance: 3 км.")
    end

    within second_hotel_selector do
      expect(page).to have_content("Отель НОГАЙ")
      expect(page).to have_content("Address: г. Казань, ул. Профсоюзная улица, 16Б")
      expect(page).to have_content("Stars: 3")
      expect(page).to have_content("Rating: 9.1")
      expect(page).to have_content("Distance: 3 км.")
    end
  end

  scenario "User searches hotels" do
    visit hotels_path

    fill_in "Search", with: "Гостиничный комплекс Татарстан"
    fill_in "Min Rating", with: "7"
    fill_in "Max Rating", with: "8"
    fill_in "Stars Amount", with: "3"

    click_on "Find"

    expect(page).to have_selector(hotel_selector, count: 1)

    within first_hotel_selector do
      expect(page).to have_content("Гостиничный комплекс Татарстан")
      expect(page).to have_content("Address: г. Казань, ул. Пушкина, 4")
      expect(page).to have_content("Stars: 3")
      expect(page).to have_content("Rating: 7.4")
      expect(page).to have_content("Distance: 3 км.")
    end
  end
end
