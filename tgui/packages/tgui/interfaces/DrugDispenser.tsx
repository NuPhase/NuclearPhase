import { useBackend, useLocalState } from "../backend";
import { Section,Button, NoticeBox, Table } from "../components";
import { Window } from "../layouts";

type Reagent = {
  name: string;
  uid: string;
  category: string;
  amount: number;
}

type InputData = {
  reagent_list: Reagent[];
  categories: string[];
}

export const DrugDispenser = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  const [selectedCategory, setSelectedCategory] = useLocalState(context, "category", null);

  const getDrugs = () => {
    if (!selectedCategory) {
      return data.reagent_list;
    }
    return data.reagent_list.filter(item => item.category == selectedCategory);
  }

  return (
    <Window width={300} height={530}>
      <Window.Content>
        <Section title="Categories">
          <Button content="All" selected={selectedCategory == null} onClick={() => setSelectedCategory(null)} />
          {data.categories.map((category, i) => (
            <Button key={i} selected={selectedCategory == category} onClick={() => setSelectedCategory(category)} >{category}</Button>
          ))}
        </Section>
        <Section title="Reagents">
          {data.reagent_list.length === 0 ? (
            <NoticeBox>Unfortunately, this dispenser is empty</NoticeBox>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell>Item</Table.Cell>
                <Table.Cell collapsing />
                <Table.Cell collapsing />
                <Table.Cell collapsing textAlign="center">
                  Dispense
                </Table.Cell>
              </Table.Row>
              {getDrugs().map(reagent => (
                <Table.Row key={reagent}>
                  <Table.Cell>{reagent.name}</Table.Cell>
                  <Table.Cell>{reagent.category}</Table.Cell>
                  <Table.Cell collapsing textAlign="right">
                    {reagent.amount}
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      content="One"
                      disabled={reagent.amount < 1}
                      onClick={() =>
                        act('dispense', {
                          name: reagent.name,
                          amount: 1,
                        })
                      }
                    />
                    <Button
                      content="Many"
                      disabled={reagent.amount <= 1}
                      onClick={() =>
                        act('dispense', {
                          name: reagent.name,
                        })
                      }
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
      </Window.Content>
    </Window>
  )
}
