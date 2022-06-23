import Foundation

protocol WeatherManagerDelegate {
    func weatherDidUpdate(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager
{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=38e8c5f6c27e0a58a17d725d8dd9832c&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(CityName: String)
    {
        let urlString = "\(weatherURL)&q=\(CityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String)
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
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data
                {
                    if let weather = self.parseJSON(weatherData: safeData)
                    {
                        self.delegate?.weatherDidUpdate(self, weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        do
        {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temperature = decodedData.main.temp
            let name = decodedData.name
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(conditionID: id, city: name, temperature: temperature)
            
            return weather
        }
        catch
        {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    
}



