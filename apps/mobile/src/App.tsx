import { SafeAreaView, ScrollView, Text } from "react-native";
import { StatusBar } from "expo-status-bar";
import { Section } from "./components/Section";

export default function App() {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: "#030712" }}>
      <StatusBar style="light" />
      <ScrollView contentContainerStyle={{ padding: 16 }}>
        <Text style={{ color: "white", fontSize: 28, fontWeight: "700", marginBottom: 16 }}>
          verified-dating-app (Mobile)
        </Text>
        <Section title="Auth + Onboarding">
          <Text style={{ color: "#d1d5db" }}>Email/Phone OTP auth + onboarding steps.</Text>
        </Section>
        <Section title="Discovery + Match">
          <Text style={{ color: "#d1d5db" }}>Swipe with filters and create matches on mutual likes.</Text>
        </Section>
        <Section title="Chat + Safety">
          <Text style={{ color: "#d1d5db" }}>Message throttle and keyword checks before send.</Text>
        </Section>
        <Section title="Verification">
          <Text style={{ color: "#d1d5db" }}>Selfie upload for pending/verified/rejected status.</Text>
        </Section>
      </ScrollView>
    </SafeAreaView>
  );
}
