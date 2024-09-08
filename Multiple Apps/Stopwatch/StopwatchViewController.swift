import UIKit
import SnapKit

final class StopwatchViewController: UIViewController {
    
    // MARK: - Properties
    
    let mainStopwatch: Stopwatch = Stopwatch()
    let lapStopwatch: Stopwatch = Stopwatch()
    var isPlay: Bool = false
    var laps: [String] = []
    
    // MARK: - UI components
    
    var timerLabel: UILabel!
    var lapTimerLabel: UILabel!
    var playPauseButton: UIButton!
    var lapRestButton: UIButton!
    var lapsTableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground    
        
        setupTimerLabel()
        setupLapTimerLabel()
        setupPlayPauseButton()
        setupLapRestButton()
        setupLapsTableView()
        
        configureButtons(playPauseButton)
        configureButtons(lapRestButton)
        
        lapRestButton.isEnabled = false
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
    }
    
    // MARK: - UI Setup
    
    func setupTimerLabel() {
        timerLabel = UILabel()
        timerLabel.text = "00:00:00"
        timerLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
        }
    }
    
    func setupLapTimerLabel() {
        lapTimerLabel = UILabel()
        lapTimerLabel.text = "00:00:00"
        lapTimerLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        lapTimerLabel.textAlignment = .center
        view.addSubview(lapTimerLabel)
        
        lapTimerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timerLabel.snp.bottom).offset(20)
        }
    }
    
    func setupPlayPauseButton() {
        playPauseButton = UIButton(type: .system)
        playPauseButton.setTitle("Start", for: .normal)
        playPauseButton.setTitleColor(.green, for: .normal)
        playPauseButton.addTarget(self, action: #selector(playPauseTimer(_:)), for: .touchUpInside)
        view.addSubview(playPauseButton)
        
        playPauseButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.top.equalTo(lapTimerLabel.snp.bottom).offset(50)
            make.width.height.equalTo(80)
        }
    }
    
    func setupLapRestButton() {
        lapRestButton = UIButton(type: .system)
        lapRestButton.setTitle("Lap", for: .normal)
        lapRestButton.setTitleColor(.black, for: .normal)
        lapRestButton.addTarget(self, action: #selector(lapResetTimer(_:)), for: .touchUpInside)
        view.addSubview(lapRestButton)
        
        lapRestButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-50)
            make.top.equalTo(lapTimerLabel.snp.bottom).offset(50)
            make.width.height.equalTo(80)
        }
    }
    
    func setupLapsTableView() {
        lapsTableView = UITableView()
        lapsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "lapCell")
        view.addSubview(lapsTableView)
        
        lapsTableView.snp.makeConstraints { make in
            make.top.equalTo(playPauseButton.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Button configurations
    
    func configureButtons(_ button: UIButton) {
        button.layer.cornerRadius = 10
    }
    
    // MARK: - Actions
    
    @objc func playPauseTimer(_ sender: AnyObject) {
        lapRestButton.isEnabled = true
        changeButton(lapRestButton, title: "Lap", titleColor: .black)
        
        if !isPlay {
            mainStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateMainTimer, userInfo: nil, repeats: true)
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
            
            RunLoop.current.add(mainStopwatch.timer, forMode: .common)
            RunLoop.current.add(lapStopwatch.timer, forMode: .common)
            
            isPlay = true
            changeButton(playPauseButton, title: "Stop", titleColor: .red)
        } else {
            mainStopwatch.timer.invalidate()
            lapStopwatch.timer.invalidate()
            isPlay = false
            changeButton(playPauseButton, title: "Start", titleColor: .green)
            changeButton(lapRestButton, title: "Reset", titleColor: .black)
        }
    }
    
    @objc func lapResetTimer(_ sender: AnyObject) {
        if !isPlay {
            resetMainTimer()
            resetLapTimer()
            changeButton(lapRestButton, title: "Lap", titleColor: .lightGray)
            lapRestButton.isEnabled = false
        } else {
            if let timerLabelText = timerLabel.text {
                laps.append(timerLabelText)
            }
            lapsTableView.reloadData()
            resetLapTimer()
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
            RunLoop.current.add(lapStopwatch.timer, forMode: .common)
        }
    }
    
    // MARK: - Helpers
    
    fileprivate func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
    }
    
    fileprivate func resetMainTimer() {
        resetTimer(mainStopwatch, label: timerLabel)
        laps.removeAll()
        lapsTableView.reloadData()
    }
    
    fileprivate func resetLapTimer() {
        resetTimer(lapStopwatch, label: lapTimerLabel)
    }
    
    fileprivate func resetTimer(_ stopwatch: Stopwatch, label: UILabel) {
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
        label.text = "00:00:00"
    }
    
    @objc func updateMainTimer() {
        updateTimer(mainStopwatch, label: timerLabel)
    }
    
    @objc func updateLapTimer() {
        updateTimer(lapStopwatch, label: lapTimerLabel)
    }
    
    func updateTimer(_ stopwatch: Stopwatch, label: UILabel) {
        stopwatch.counter += 0.035
        
        let minutes = String(format: "%02d", Int(stopwatch.counter / 60))
        let seconds = String(format: "%.2f", stopwatch.counter.truncatingRemainder(dividingBy: 60))
        label.text = "\(minutes):\(seconds)"
    }
}

// MARK: - UITableViewDataSource

extension StopwatchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath)
        cell.textLabel?.text = "Lap \(laps.count - indexPath.row) - \(laps[laps.count - indexPath.row - 1])"
        return cell
    }
}

// MARK: - Extension

fileprivate extension Selector {
    static let updateMainTimer = #selector(StopwatchViewController.updateMainTimer)
    static let updateLapTimer = #selector(StopwatchViewController.updateLapTimer)
}
