
def consolidate_cart(cart)
  list = {}
  all_items = []
  cart.collect do |hashes|
    hashes.collect do |items, info|
    all_items << items
    list[items] = {}
    info.collect do |k, v|
    list[items][k]={}
    list[items][k]=v
    list[items][:count]= all_items.count(items)
   end
  end
 end
list 
end




=begin
def apply_coupons(cart, coupons)
 
  coupons.collect do |hashes|
   if cart["#{hashes[:item]}"][:count] >= hashes[:num]
     cart["#{hashes[:item]} W/COUPON"]={}

     cart["#{hashes[:item]} W/COUPON"][:clearance] = cart["#{hashes[:item]}"][:clearance]
     
     cart["#{hashes[:item]} W/COUPON"][:count] = cart["#{hashes[:item]}"][:count] / hashes[:num]
     cart["#{hashes[:item]}"][:count] -= hashes[:num]#cart["#{hashes[:item]} W/COUPON"][:count] * hashes[:num]

     cart["#{hashes[:item]} W/COUPON"][:price] = hashes[:cost] #cart["#{hashes[:item]} W/COUPON"][:count] * hashes[:cost]  return the original coupon price
   end
  end
  cart
end

=end

def apply_coupons(cart, coupons)
  coupons.each do |hashes|
    if cart["#{hashes[:item]}"] && cart["#{hashes[:item]}"][:count] >= hashes[:num]
      if cart["#{hashes[:item]} W/COUPON"]

       cart["#{hashes[:item]} W/COUPON"][:count] += 1      #why we don't create the empty hash here is because we want to increment the count. in order to do that, we need to have a count number already. (meaning count attribute exist)

     else
       cart["#{hashes[:item]} W/COUPON"]={}  
       cart["#{hashes[:item]} W/COUPON"][:clearance] = cart["#{hashes[:item]}"][:clearance]   
       cart["#{hashes[:item]} W/COUPON"][:count] = 1#= cart["#{hashes[:item]} W/COUPON"][:count]
       cart["#{hashes[:item]} W/COUPON"][:price] = hashes[:cost]
       
    end
       cart["#{hashes[:item]}"][:count] -= hashes[:num]
   end
 end
  cart
end



def apply_clearance(cart)
  cart.collect do |items, info|
   if info[:clearance] == true
    info[:price] *= 0.8
    info[:price]=info[:price].round(2)
   end
  end
  cart
end



def checkout(cart, coupons)
  original_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(original_cart, coupons)
  cart_with_coupons_clearance = apply_clearance(cart_with_coupons)
  
  total = 0
  cart_with_coupons_clearance.collect do |items, info|
    total += info[:count] * info[:price]
  end
  (total > 100)? total *= 0.9 : total
  total
end
