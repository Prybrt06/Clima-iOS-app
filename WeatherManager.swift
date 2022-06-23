import Foundation

struct WeatherManager
{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=38e8c5f6c27e0a58a17d725d8dd9832c&units=metric"
    
    func fetchWeather(CityName: String)
    {
        let urlString = "\(weatherURL)&q=\(CityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String)
    {
        //1. Create a URL
        
        if let url = URL(string: urlString)
        {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error )in
                if error != nil
                {
                    print(error!)
                    return
                }
                
                if let safeData = data
                {
                    self.parseJSON(weatherData: safeData)
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data)
    {
        let decoder = JSONDecoder()
        do
        {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
        }
        catch
        {
            print(error)
        }
    }
}



