import { StatusBar } from "expo-status-bar";
import {
  StyleSheet,
  Text,
  View,
  ScrollView,
  RefreshControl,
} from "react-native";
import axios, { Axios } from "axios";
import { useEffect, useState } from "react";

const url = "";

export default function App() {
  const url = " https://9d21-120-89-90-57.ngrok.io";

  type Product = {
    id: number;
    name: string;
    price: number;
    stock: number;
    tag: string;
    image: string;
    category_id: number;
    created_at: string;
    updated_at: string;
  };

  const [product, setProduct] = useState<Product[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [refreshing, setRefreshing] = useState(false);

  const getProducts = async () => {
    setLoading(true);
    setRefreshing(true);
    try {
      const response = await axios.get(`${url}/api/products`);
      setProduct(response.data.data);
      setLoading(false);
      setRefreshing(false);
    } catch (error: any) {
      setError(error.message);
      setLoading(false);
      setRefreshing(false);
    }
  };

  useEffect(() => {
    getProducts();
  }, []);

  const onRefresh = () => {
    getProducts();
  };

  return (
    <View>
      {loading && <Text>Loading..</Text>}
      {error && <Text>{error}</Text>}
      {product &&
        product.map((item, index) => (
          <ScrollView
            key={index}
            refreshControl={
              <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
            }
          >
            <Text>Name: {item.name}</Text>
            <Text>Price: {item.price}</Text>
            <Text>Stock: {item.stock}</Text>
            <Text>Tag: {item.tag}</Text>
          </ScrollView>
        ))}
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
