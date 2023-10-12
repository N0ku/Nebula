import UIKit

class ObservableCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentContainerView: UIView! // This is the container view added in the storyboard/XIB
    @IBOutlet weak var circleShadow: UIView!
    @IBOutlet weak var imageShadow: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCellAppearance(index: Int) {
        // Make the cell circular
        contentContainerView.layer.cornerRadius = contentContainerView.frame.width / 2
        contentContainerView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        
        // Define an array of colors based on your index
        let colors: [CGColor] = [
            UIColor(red: 0.03921568627, green: 0.50588235294, blue: 0.60784313725, alpha: 1).cgColor,
            UIColor(red: 0.87058823529, green: 0.19607843137, blue: 0.88235294117, alpha: 1).cgColor,
            UIColor(red: 0.03921568627, green: 0.16470588235, blue: 0.60784313725, alpha: 1).cgColor,
            UIColor(red: 0.4431372549, green: 0.87843137255, blue: 0.6431372549, alpha: 1).cgColor
        ]

        
        let color = colors[index % colors.count]
        
        imageShadow.clipsToBounds = false
        imageShadow.layer.cornerRadius = imageView.frame.width / 2
        imageShadow.layer.shadowColor = UIColor.lightGray.cgColor
        imageShadow.layer.shadowOpacity = 1
        imageShadow.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageShadow.layer.shadowRadius = 4
        
        
        // Add a linear gradient to the background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentContainerView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = [UIColor.black.cgColor, color]
        
        contentContainerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Apply drop shadow effect
        circleShadow.clipsToBounds = false
        circleShadow.backgroundColor = UIColor.clear
        circleShadow.layer.cornerRadius = contentContainerView.frame.width / 2
        circleShadow.layer.shadowColor = color
        circleShadow.layer.shadowOpacity = 0.5
        circleShadow.layer.shadowOffset = CGSize(width: 0, height: 10)
        circleShadow.layer.shadowRadius = 4
    }
    
    func configure(name: String, imageURL: String) {
        nameLabel.text = name
        
        if let url = URL(string: imageURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }.resume()
        }
    }
}
