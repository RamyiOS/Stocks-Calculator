//
//  CalculatorTableVC.swift
//  Stocks
//
//  Created by Mac on 6/27/22.
//  Copyright © 2022 ramy. All rights reserved.
//

import UIKit
import Combine

class CalculatorTableVC: UITableViewController {
    
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var investsLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var annualReturnLabel: UILabel!
    @IBOutlet weak var initialInvestsTextField: UITextField!
    @IBOutlet weak var monthlyInvestsTextField: UITextField!
    @IBOutlet weak var initialDateTextField: UITextField!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var investsCurrencyLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var dateSlider: UISlider!
    @IBOutlet weak var roiCurrencyLabel: UILabel!
    @IBOutlet weak var currentValueCurrencyLabel: UILabel!
    @IBOutlet weak var currentValueTitleLabel: UILabel!
    
    @Published private var initialDate: Int?
    @Published private var initialInvests: Int?
    @Published private var monthlyInvests: Int?
    
    private var subscribers = Set<AnyCancellable>()
    private let dcaService = DCAService()
    private let calculatorPresenter = CalculatorPresenter()
    var asset: Asset?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configerViews()
        configerTextFields()
        configerDateSlider()
        observeForm()
        resetViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialInvestsTextField.becomeFirstResponder()
    }
    
    
    private func configerViews() {
        navigationItem.title = asset?.stocksResult.symbol
        navigationController?.navigationBar.tintColor = .systemGreen
        symbolLabel.text = asset?.stocksResult.symbol
        investsCurrencyLabel.text = asset?.stocksResult.currency
        roiCurrencyLabel.text = asset?.stocksResult.currency
        currentValueCurrencyLabel.text = asset?.stocksResult.currency
        nameLabel.text = asset?.stocksResult.name
        currencyLabels.forEach { (label) in
            label.text = asset?.stocksResult.currency.addBrackets()
        }
    }
    
    private func configerTextFields() {
        initialInvestsTextField.addDoneButton()
        monthlyInvestsTextField.addDoneButton()
        initialDateTextField.delegate = self
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: Title.noDates, message: Message.alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: Title.ok, style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func configerDateSlider() {
        if let count = asset?.timeSeriesMonthlyAdjusted.getMonthInfos().count, count != 0 {
            let dateSliderCount = count - 1
            dateSlider.maximumValue = dateSliderCount.floatValue
        } else {
            dateSlider.isHidden = true
            showAlert()
        }
    }
    
    @IBAction func dateSliderDidChange(_ sender: UISlider) {
        initialDate = Int(sender.value)
    }
    
    private func observeInitialDate() {
        $initialDate.sink { [weak self] (index) in
            guard let self = self, let index = index else { return }
            
            self.dateSlider.value = index.floatValue
            if let dateString = self.asset?.timeSeriesMonthlyAdjusted.getMonthInfos()[index].date.MMYYFormat {
                self.initialDateTextField.text = dateString
            }
        }.store(in: &subscribers)
    }
    
    private func observeInitialInvestsTextField() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestsTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self] (text) in
            guard let self = self else { return }
            self.initialInvests = Int(text) ?? 0
        }.store(in: &subscribers)
    }
    
    private func observemMnthlyInvestsTextField() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyInvestsTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self] (text) in
            guard let self = self else { return }
            self.monthlyInvests = Int(text) ?? 0
        }.store(in: &subscribers)
    }
    
    private func publishersCombineLatest3() {
        Publishers.CombineLatest3($initialInvests, $monthlyInvests, $initialDate).sink { [weak self] (initialInvests, monthlyInvests, initialDateOfInvests) in
            guard let self = self, let initialInvesedAmount = initialInvests,
                let monthlyInvests = monthlyInvests,
                let initialDateOfInvests = initialDateOfInvests,
                let asset = self.asset else { return }
            
            let result = self.dcaService.calculate(asset: asset, initialInvesedAmount: initialInvesedAmount.doubleValue, monthlyInvests: monthlyInvests.doubleValue, initialDateOfInvests: initialDateOfInvests)
            self.assignViews(result: result)
        }.store(in: &subscribers)
    }
    
    private func assignViews(result: DCAResult) {
        let presentation = self.calculatorPresenter.getPresentation(result: result)
        let labels = [investsCurrencyLabel, roiCurrencyLabel, gainLabel, currentValueTitleLabel, currentValueCurrencyLabel]
        for label in labels {
            label?.textColor = result.isProfitable ? .systemGreen : .systemRed
        }
        
        self.currentValueLabel.textColor = presentation.currentValueLabelTextColor
        self.currentValueLabel.text = presentation.currentValue
        self.investsLabel.text = presentation.investmentAmount
        self.investsLabel.textColor = presentation.currentValueLabelTextColor
        self.gainLabel.text = presentation.gain
        self.yieldLabel.text = presentation.yield
        self.yieldLabel.textColor = presentation.yieldLabelTextColor
        self.annualReturnLabel.text = presentation.annualReturn
        self.annualReturnLabel.textColor = presentation.annualReturnLabelTextColor
    }
    
    private func observeForm() {
        self.observeInitialDate()
        self.observeInitialInvestsTextField()
        self.observemMnthlyInvestsTextField()
        self.publishersCombineLatest3()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.showInvestDate,
            let dateSelectionTableVC = segue.destination as? DateSelectionTableVC,
            let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted {
            dateSelectionTableVC.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
            dateSelectionTableVC.selectedIndex = initialDate
            dateSelectionTableVC.didSelectDate = { [weak self] index in
                guard let self = self else { return }
                self.handleDateSelection(at: index)
            }
        }
    }
    
    private func handleDateSelection(at index: Int) {
        guard navigationController?.visibleViewController is DateSelectionTableVC else { return }
        navigationController?.popViewController(animated: true)
        if let monthInfos = asset?.timeSeriesMonthlyAdjusted.getMonthInfos() {
            initialDate = index
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.MMYYFormat
            initialDateTextField.text = dateString
        }
    }
    
    private func resetViews() {
        currentValueLabel.text = DefaultValue.zeros
        investsLabel.text = DefaultValue.zeros
        gainLabel.text = DefaultValue.dash
        yieldLabel.text = DefaultValue.dash
        annualReturnLabel.text = DefaultValue.dash
    }
}


extension CalculatorTableVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateTextField {
            performSegue(withIdentifier: Identifier.showInvestDate, sender: asset?.timeSeriesMonthlyAdjusted)
            return false
        }
        return true
    }
}
