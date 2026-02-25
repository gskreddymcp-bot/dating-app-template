import { PropsWithChildren } from "react";
import { View, Text } from "react-native";

export function Section({ title, children }: PropsWithChildren<{ title: string }>) {
  return (
    <View style={{ marginBottom: 16, padding: 12, backgroundColor: "#111827", borderRadius: 10 }}>
      <Text style={{ color: "#fff", fontWeight: "600", marginBottom: 8 }}>{title}</Text>
      {children}
    </View>
  );
}
