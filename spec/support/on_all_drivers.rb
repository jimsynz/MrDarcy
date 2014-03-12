module OnAllDrivers
  def on_all_drivers
    [:Synchronous, :Thread, :Celluloud].each do |driver|
      describe "Using #{driver}" do
        before { MrDarcy.driver = driver }
        after  { MrDarcy.driver = :Synchronous }
        yield
      end
    end
  end
end
