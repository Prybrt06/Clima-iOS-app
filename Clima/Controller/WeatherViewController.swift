import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var locationSearchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSearchTextField.placeholder = "Enter a City Name"
        
        weatherManager.delegate = self
        locationSearchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        locationSearchTextField.endEditing(true)
        print(locationSearchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationSearchTextField.endEditing(true)
        print(locationSearchTextField.text!)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if locationSearchTextField.text != ""
        {
            return true;
        }

        else
        {
            locationSearchTextField.placeholder = "type something.."
            return false;
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = locationSearchTextField.text
        {
            weatherManager.fetchWeather(CityName: city)
        }

        locationSearchTextField.text = ""
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel) {
        print(weather.temperature)
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}

