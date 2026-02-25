import { Panel, Button } from "../../components/ui";

export default function UsersPage() {
  return (
    <Panel title="Users + Bans">
      <p>Search, view, and ban users. Ban actions write audit entries.</p>
      <div className="mt-3"><Button>Ban Selected</Button></div>
    </Panel>
  );
}
