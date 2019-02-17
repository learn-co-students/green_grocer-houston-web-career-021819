require 'pry'

def consolidate_cart(cart)
  final_hash  = {}
  cart.each do |i|
    i.each do |item, info|
      new_hash = info
      if final_hash[item] == nil
        new_hash[:count] = 1
        final_hash[item] = new_hash
      else
        final_hash[item][:count] += 1
      end
    end
  end
  final_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |separate_coupons|
    main = separate_coupons[:item]
    if cart[main] && cart[main][:count] >= separate_coupons[:num]
      if cart["#{main} W/COUPON"]
        cart["#{main} W/COUPON"][:count] += 1
      else
        cart["#{main} W/COUPON"] = {
        :price => separate_coupons[:cost],
        :clearance => cart[main][:clearance],
        :count => 1
        }
      end
      cart[main][:count] -= separate_coupons[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    info.each do |key, value|
      if key == :clearance && value == true
        cart[item][:price] = cart[item][:price] * 8 / 10
      end
    end
  end
  cart
end

def checkout(cart, coupons)
  #binding.pry
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  clearanced_cart = apply_clearance(couponed_cart)
  #binding.pry
  total = 0.00
  clearanced_cart.each do |item, info|
    info.each do |key, value|
      if key == :price
        total += value
      end
    end
  end
  if total > 100
    total = total * 9 / 10
  end
  total
end
