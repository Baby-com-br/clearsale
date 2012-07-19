# encoding: utf-8
require 'spec_helper'

module Clearsale
  describe Order do
    describe ".to_xml" do
      it "converts the order to xml successfully" do
        _order = Object.new(order)
        _payment = Object.new(payment)
        _user = Object.new(user)
        described_class.to_xml(_order, _payment, _user).should match %r{ClearSale><Orders><Order><ID>1234</ID><Date>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}</Date><Email>petergriffin@abc\.com</Email><TotalItens>20.0</TotalItens><TotalOrder>25.0</TotalOrder><QtyInstallments>3</QtyInstallments><QtyItems>3</QtyItems><IP>127.0.0.1</IP><CollectionData><ID>8888</ID><Type>1</Type><LegalDocument1>24878346337</LegalDocument1><Name>Peter Löwenbräu Griffin</Name><BirthDate>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}</BirthDate><Email>petergriffin@abc.com</Email><Genre>m</Genre><Address><Street>Bla St</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><ZipCode>00100-011</ZipCode></Address><Phones><Phone><Type>0</Type><DDD>11</DDD><Number>80011002</Number></Phone></Phones></CollectionData><ShippingData><ID>8888</ID><Type>1</Type><LegalDocument1>24878346337</LegalDocument1><Name>Peter Löwenbräu Griffin</Name><BirthDate>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}</BirthDate><Email>petergriffin@abc.com</Email><Genre>m</Genre><Address><Street>Bla St</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><ZipCode>00100-011</ZipCode></Address><Phones><Phone><Type>0</Type><DDD>11</DDD><Number>80011002</Number></Phone></Phones></ShippingData><Payments><Payment><Date>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}</Date><Amount>50\.0</Amount><PaymentTypeID>1</PaymentTypeID><QtyInstallments>3</QtyInstallments><CardNumber>2222</CardNumber><CardBin>1234432</CardBin><CardType>4</CardType><CardExpirationDate>05/2012</CardExpirationDate><Name></Name><LegalDocument>24878346337</LegalDocument><Address><Street>Bla St</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><ZipCode>00100-011</ZipCode></Address></Payment></Payments><Items><Item><ID>5555</ID><Name>Pogobol</Name><ItemValue>5.0</ItemValue><Qty>2</Qty><CategoryID>7777</CategoryID><CategoryName>Disney</CategoryName></Item><Item><ID>5555</ID><Name>Pogobol</Name><ItemValue>5.0</ItemValue><Qty>2</Qty><CategoryID>7777</CategoryID><CategoryName>Disney</CategoryName></Item></Items></Order></Orders></ClearSale>}
      end
    end
  end
end
