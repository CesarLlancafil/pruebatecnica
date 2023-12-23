import React, { useState, useEffect } from 'react';
import { data } from '../data/productData';

const ProductList = () => {

  const [showData, setShowData] = useState(data)
  const [filteredData, setFilteredData] = useState(data);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    setShowData(data)
  }, []);

  const handleFilterChange = (e) => {
    if(e.target.value == ''){
        setShowData(data)
    }
    else{
        const filterResult = filteredData.filter(item => item.Ean.nombre_producto.toLowerCase().includes(e.target.value.toLowerCase()))
        setShowData(filterResult)
    }
    setSearchTerm(e.target.value);
  };

  return (
    <div>
      <input
        type="text"
        placeholder="Filtrar por nombre"
        onChange={handleFilterChange}
      />
      {showData.map((product, index) => (
        <div key={index}>
          <h3>{product.Ean.nombre_producto}</h3>
          <p>Rango de precios: {product.Ean.rango_de_precios}</p>
          <p>Mercados diferentes: {product.Ean.cantidad_de_markets_diferentes}</p>
        </div>
      ))}
    </div>
  );
};


export default ProductList;