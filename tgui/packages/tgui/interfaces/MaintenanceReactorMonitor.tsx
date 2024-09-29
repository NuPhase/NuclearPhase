import { useBackend} from "../backend";
import { LabeledList, Box, Section, Flex, ProgressBar, BlockQuote } from "../components";
import { Window } from "../layouts";

type Log = {
  content: string;
  color: string;
  is_bold: boolean;
}

type InputData = {
  loglist: Log[];
  blanket_integrity: number;
  divertor_integrity: number;
  magnet_integrity: number;
  structure_integrity: number;
}

export const MaintenanceReactorMonitor = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  return (
    <Window width = {700} height = {530} theme="ntos">
      <Window.Content>
        <Flex>
          <Flex.Item height={40}>
            <Section title = "Message Log"
              fill
              backgroundColor="black">
              {data.loglist.map(Log => (
                <Box
                  mb = {2}
                  textColor = {Log.color}
                  bold = {Log.is_bold}>
                  {Log.content}
                </Box>
              ))}
            </Section>
          </Flex.Item>
          <Flex.Item height={20}>
            <Section title = " Maintenance Data">
              <BlockQuote>All integrity values are related to a TFC (Total Failure Condition).</BlockQuote>
              <LabeledList>
                <LabeledList.Item label = "Blanket TFC Integrity">
                  <ProgressBar
                    ranges={{
                    bad: [0, 40],
                    good: [80, 100],
                    average: [40, 80]
                    }}
                    minValue = {0}
                    maxValue = {100}
                    value={data.blanket_integrity}>
                  {data.blanket_integrity}%
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label = "Divertor TFC Integrity">
                  <ProgressBar
                    ranges={{
                    bad: [0, 40],
                    good: [80, 100],
                    average: [40, 80]
                    }}
                    minValue = {0}
                    maxValue = {100}
                    value={data.divertor_integrity}>
                  {data.divertor_integrity}%
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label = "Magnets TFC Integrity">
                  <ProgressBar
                    ranges={{
                    bad: [0, 40],
                    good: [80, 100],
                    average: [40, 80]
                    }}
                    minValue = {0}
                    maxValue = {100}
                    value={data.magnet_integrity}>
                  {data.magnet_integrity}%
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label = "Overall Structural Integrity">
                  <ProgressBar
                    ranges={{
                    bad: [0, 40],
                    good: [80, 100],
                    average: [40, 80]
                    }}
                    minValue = {0}
                    maxValue = {100}
                    value={data.structure_integrity}>
                  {data.structure_integrity}%
                  </ProgressBar>
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section title = " Fuel Data">
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  )
}
