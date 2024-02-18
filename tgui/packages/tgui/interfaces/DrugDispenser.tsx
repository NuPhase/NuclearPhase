import { useBackend} from "../backend";
import { LabeledList, Box, Section, Flex, ProgressBar } from "../components";
import { Window } from "../layouts";

type Reagent = {
  name: string;
  category: string;
  amount: number;
}

type InputData = {
  reagentlist: Reagent[];
}

interface CategoryArray {
  [key: string]: reagents_in_category
}

export const DrugDispenser = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  let category_array: CategoryArray[] = []
  let reagents_in_category: Array<string>

  return (
    <Window width = {650} height = {530}>
      <Window.Content>

      </Window.Content>
    </Window>
  )
}
