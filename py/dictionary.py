import pandas as pd

def groupProducts (queryData):
    # Crear un DataFrame con los datos de la query
    df = pd.DataFrame(queryData, columns=['ProductName', 'Ean', 'Sku', 'Market', 'LastLowestPrice', 'LastLowestDiscountPrice'])

    groupedProducts = []

    # Agrupar por EAN
    for ean, group in df.groupby('Ean'):
        productName = group['ProductName'].iloc[0]
        queryData = group[['ProductName', 'Ean', 'Sku', 'Market', 'LastLowestPrice', 'LastLowestDiscountPrice']].to_dict(orient='records')
        diffMarkets = len(group['Market'].unique())
        priceRange = "{} - {}".format(group['LastLowestPrice'].max(), group['LastLowestPrice'].min())
        
        productDict = {
            "Ean": {
                "nombre_producto": productName,
                "datos_query": queryData,
                "cantidad_de_markets_diferentes": diffMarkets,
                "rango_de_precios": priceRange
            }
        }
        groupedProducts.append(productDict)

    return groupedProducts
#Usando datos de query obtenidos en la pregunta 1
queryExample = [
    {"ProductName": "Product 1", "Ean": "EAN001", "Sku": "SKU001", "Market": "Market A", "LastLowestPrice": 18.00, "LastLowestDiscountPrice": 12.00},
    {"ProductName": "Product 2", "Ean": "EAN002", "Sku": "SKU002", "Market": "Market A", "LastLowestPrice": 22.00, "LastLowestDiscountPrice": 18.00},
    {"ProductName": "Product 3", "Ean": "EAN003", "Sku": "SKU003", "Market": "Market B", "LastLowestPrice": 28.00, "LastLowestDiscountPrice": 22.00},
    {"ProductName": "Product 1", "Ean": "EAN001", "Sku": "SKU004", "Market": "Market C", "LastLowestPrice": 15.00, "LastLowestDiscountPrice": 10.00},
    {"ProductName": "Product 2", "Ean": "EAN002", "Sku": "SKU005", "Market": "Market C", "LastLowestPrice": 20.00, "LastLowestDiscountPrice": 15.00},
]

results = groupProducts(queryExample)

for product in results:
    print(product)