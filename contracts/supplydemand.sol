pragma solidity >=0.4.21 <0.7.0;

contract SupplyDemand{
    
    struct Product{
        uint32 amount;
        uint32 kgPrice;//this should be float
        bool exists;
    }
    
    mapping(string => Product) SupplierProducts;
    
    function getProductAmount (string memory _productName) public view returns(uint32){
        return SupplierProducts[_productName].amount;
    }
    
    function getProductPrice (string memory _productName) public view returns(uint32){
        require(SupplierProducts[_productName].exists);
        return SupplierProducts[_productName].kgPrice;
    }
    
    function changeProductStock (string memory _productName,uint32 _newAmount) public {
        require(SupplierProducts[_productName].exists);
        
        SupplierProducts[_productName].amount=_newAmount;
    }
    
    function changeProductPrice(string memory _productName, uint32 _newPrice) public{
        require(SupplierProducts[_productName].exists);
        
        SupplierProducts[_productName].kgPrice=_newPrice;
    }
    
    function buyProduct(string memory _productName, uint32 _amount, uint32 _paymentAmount) public{
        
        Product storage product=SupplierProducts[_productName];
        require(product.exists);
        require(_amount<= product.amount);
        require(_paymentAmount == (product.kgPrice * _amount));
        
        product.amount-=_amount;
    }
    
    function addProduct(string memory _productName, uint32 _amount, uint32 _kgPrice) public{
        
        SupplierProducts[_productName]= Product({
           amount :_amount,
           kgPrice : _kgPrice,
           exists: true
        });
    }
    
}