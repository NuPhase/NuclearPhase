import { useBackend, useLocalState } from "../backend";
import { Section,Button, NoticeBox, Table, NumberInput, Tooltip, Box } from 'tgui-core/components';
import { Window } from "../layouts";

type Reagent = {
  name: string;
  description: string;
  uid: string;
  category: string;
  amount: number;
  rtype: string;
}

type InputData = {
  reagent_list: Reagent[];
  categories: string[];
  vial_available: boolean;
  syringe_available: boolean;
  iv_pack_available: boolean;
  dosage: number;
}

export const DrugDispenser = (props: any) => {
  const { act, data } = useBackend<InputData>();
  const [selectedCategory, setSelectedCategory] = useLocalState("category", null);
  const [dispense_type, setDispenseType] = useLocalState("dispense_type", null);

  const getDrugs = () => {
    if (!selectedCategory) {
      return data.reagent_list;
    }
    return data.reagent_list.filter(item => item.category == selectedCategory);
  }

  return (
    <Window width={400} height={530}>
      <Window.Content>
        <Section title = "Dispensing">
          Type:
          <Button
            selected = {dispense_type == "syringe"}
            disabled = {!data.syringe_available}
            onClick = {() => setDispenseType("syringe")}>
          Syringe</Button>
          <Button
            selected = {dispense_type == "vial"}
            disabled = {!data.vial_available}
            onClick = {() => setDispenseType("vial")}>
          Vial</Button>
          <Button
            selected = {dispense_type == "ivpack"}
            disabled = {!data.iv_pack_available}
            onClick = {() => setDispenseType("ivpack")}>
          IV Pack</Button>
          Dosage:
          <NumberInput
            animated = {true}
            value = {data.dosage}
            unit = "mg/ml"
            minValue = {0.01}
            maxValue = {1}
            step = {0.01}
            stepPixelSize = {3}
            onChange={(value) => act('change_dosage', { new_dosage: value, })}
            >
          </NumberInput>
        </Section>
        <Section title="Categories">
          <Button content="All" selected={selectedCategory == null} onClick={() => setSelectedCategory(null)} />
          {data.categories.map((category, i) => (
            <Button key={i} selected={selectedCategory == category} onClick={() => setSelectedCategory(category)} >{category}</Button>
          ))}
        </Section>
        <Section title="Reagents">
          {data.reagent_list.length === 0 ? (
            <NoticeBox>Unfortunately, this dispenser is empty.</NoticeBox>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell>Name</Table.Cell>
                <Table.Cell collapsing>Category</Table.Cell>
                <Table.Cell collapsing textAlign="center">
                  Amount
                </Table.Cell>
              </Table.Row>
              {getDrugs().map(reagent => (
                <Table.Row key={reagent}>
                  <Table.Cell><Tooltip content={reagent.description}><Box position="relative">{reagent.name}</Box></Tooltip></Table.Cell>
                  <Table.Cell>{reagent.category}</Table.Cell>
                  <Table.Cell collapsing textAlign="center">
                    {reagent.amount}ml
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      color = "cyan"
                      tooltip = "Dispense the reagent in a selected container."
                      onClick = {() => act('dispense', { "dispense_string" : dispense_type, "reagent_type" : reagent.rtype})}
                      >Dispense
                    </Button>
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
