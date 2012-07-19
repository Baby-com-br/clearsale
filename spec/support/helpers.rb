# encoding: utf-8

def product
  {
    :id => 5555,
    :name => 'Pogobol',
    :category => { :id => 7777, :name => 'Disney' }
  }
end

def item1
  {
    :product => product,
    :price => 5.00,
    :quantity => 2,
  }
end

def address
  {
    :street_name => 'Bla St',
    :number => '123',
    :complement => '',
    :neighborhood => 'Rhode Island',
    :city => 'Mayland',
    :state => 'Maryland',
    :postal_code => '00100-011'
  }
end

def user
  {
    :email     => 'petergriffin@abc.com',
    :id        => 8888,
    :cpf       => '248.783.463-37',
    :full_name => 'Peter Löwenbräu Griffin',
    :birthdate => 40.years.ago,
    :phone     => '11 8001 1002',
    :gender    => 'm',
    :last_sign_in_ip => '127.0.0.1',
  }
end

def order
  {
    :id => 1234,
    :paid_at => 2.seconds.ago,
    :billing_address => address,
    :installments => 3,
    :total_items => 20.00,
    :total_order => 25.00,
    :items_count => 3,
    :created_at => Time.current,
    :user => user,
    :order_items => [item1, item1],
  }
end

def payment
  {
    :card_holder => 'Petter L Griffin',
    :card_number => '1234432111112222',
    :card_expiration => '05/2012',
    :card_security_code => '123',
    :acquirer => 'visa',
    :amount => 50.00,
  }
end
