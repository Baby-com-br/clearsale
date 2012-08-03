require 'builder'
require 'ostruct'

module Clearsale
  class Order
    CARD_TYPE_MAP = {
      :visa       => 3,
      :mastercard => 2,
      :amex       => 5,
    }
    def self.to_xml(order, payment, user)
      builder = Builder::XmlMarkup.new
      xml = builder.tag!("ClearSale") do |b|
        b.tag!('Orders') do |b|
          b.tag!('Order') do |b|
            build_order(b, order, payment, user)
          end
        end
      end.to_s
      xml
    end

    def self.build_order(builder, order, payment, user)
      builder.tag!('ID', order.id)
      builder.tag!('Date', order.created_at.strftime("%Y-%m-%dT%H:%M:%S"))
      builder.tag!('Email', user.email)
      builder.tag!('TotalItens', order.total_items)
      builder.tag!('TotalOrder', order.total_order)
      builder.tag!('QtyInstallments', order.installments)
      builder.tag!('QtyItems', order.items_count)
      builder.tag!('IP', user.last_sign_in_ip)
      builder.tag!('CollectionData') do |b|
        build_user_data(b, user, order.billing_address)
      end
      builder.tag!('ShippingData') do |b|
        build_user_data(b, user, order.shipping_address)
      end

      builder.tag!('Payments') do |b|
        build_payment_data(b, order, payment, user)
      end

      builder.tag!('Items') do |b|
        order.order_items.each do |order_item|
          build_item(b, order_item)
        end
      end
    end

    def self.build_user_data(builder, user, billing_address)
      builder.tag!('ID', user.id)
      builder.tag!('Type', 1) # Pessoa Física
      builder.tag!('LegalDocument1', user.cpf.gsub(/[\.\-]*/, '').strip)
      builder.tag!('Name', user.full_name)
      builder.tag!('BirthDate', user.birthdate.to_time.strftime("%Y-%m-%dT%H:%M:%S")) if user.birthdate.present?
      builder.tag!('Email', user.email)
      builder.tag!('Genre', user.gender.downcase)
      build_address(builder, billing_address)
      builder.tag!('Phones') do |b|
        build_phone(b, user)
      end
    end

    def self.build_address(builder, address)
      builder.tag!('Address') do |b|
        builder.tag!('Street', address.street_name)
        builder.tag!('Number', address.number)
        builder.tag!('Comp', address.complement)
        builder.tag!('County', address.neighborhood)
        builder.tag!('City', address.city)
        builder.tag!('State', address.state)
        builder.tag!('ZipCode', address.postal_code)
      end
    end

    def self.build_phone(builder, user)
      if user.phone.present?
        stripped_phone = user.phone.gsub(/\(*\)*\s*\-*/, '')

        builder.tag!('Phone') do |b|
          b.tag!('Type', 0) # Undefined
          b.tag!('DDD', stripped_phone[0..1])
          b.tag!('Number', stripped_phone[2..-1])
        end
      end
    end

    def self.build_payment_data(builder, order, payment, user)
      builder.tag!('Payment') do |b|
        paid_at = order.paid_at || Time.current

        b.tag!('Date', paid_at.strftime("%Y-%m-%dT%H:%M:%S"))
        b.tag!('Amount', payment.amount)

        #is_credit_card
        b.tag!('PaymentTypeID', 1)

        b.tag!('QtyInstallments', order.installments)

        b.tag!('CardNumber', payment.card_number)
        b.tag!('CardBin', payment.card_number[0..5])
        b.tag!('CardType', CARD_TYPE_MAP.fetch(payment.acquirer.to_sym, 4)) # Failover is 'outros'
        b.tag!('CardExpirationDate', payment.card_expiration)
        b.tag!('Name', payment.customer_name)
        b.tag!('LegalDocument', user.cpf.gsub(/[\.\-]*/, '').strip)

        build_address(b, order.billing_address)
      end
    end

    def self.build_item(builder, order_item)
      builder.tag!('Item') do |b|
        b.tag!('ID', order_item.product.id)
        b.tag!('Name', order_item.product.name)
        b.tag!('ItemValue', order_item.price)
        b.tag!('Qty', order_item.quantity)
        b.tag!('CategoryID', order_item.product.category.id) if order_item.product.category.try(:id).present?
        b.tag!('CategoryName', order_item.product.category.name) if order_item.product.category.try(:name).present?
      end
    end
  end
end
