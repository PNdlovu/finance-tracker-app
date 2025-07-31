class PortfolioAnalytics
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def total_value
    user.user_stocks.includes(:stock).sum { |us| us.stock.last_price || 0 }
  end

  def daily_change
    # This would need to store historical prices
    # For now, return a placeholder
    { amount: 0, percentage: 0 }
  end

  def top_performers(limit = 5)
    user.stocks.order(last_price: :desc).limit(limit)
  end

  def portfolio_distribution
    total = total_value
    return [] if total == 0

    user.user_stocks.includes(:stock).map do |user_stock|
      stock = user_stock.stock
      value = stock.last_price || 0
      {
        ticker: stock.ticker,
        name: stock.name,
        value: value,
        percentage: (value / total * 100).round(2)
      }
    end
  end

  def diversity_score
    # Simple diversity score based on number of stocks
    stock_count = user.stocks.count
    case stock_count
    when 0..2 then "Low"
    when 3..5 then "Medium"
    when 6..10 then "Good"
    else "Excellent"
    end
  end

  def recommendations
    recommendations = []
    
    if user.stocks.count < 5
      recommendations << {
        type: 'diversification',
        message: 'Consider adding more stocks to diversify your portfolio',
        priority: 'high'
      }
    end

    # Add more intelligent recommendations based on portfolio composition
    recommendations
  end
end