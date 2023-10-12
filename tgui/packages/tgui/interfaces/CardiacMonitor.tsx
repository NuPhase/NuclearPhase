import { useBackend, useLocalState } from "../backend";
import { Box, LabeledList, ProgressBar, Section, Tabs } from "../components";
import { Window } from "../layouts";

type InputData = {
  name: string;
  status: string;
  pulse: number;
  pressure: string;
  saturation: number;
  rhythm: string;
  breath_rate: number;
  tpvr: number;
  mcv: number;
}

export const CardiacMonitor = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  return (
    <Window width={800} height={600}>
      <Window.Content>
        <Section fontSize = {1.5}>
          <Box textColor = "red" mb = {3}>
            ECG BPM
            <Box textAlign = "left" fontSize = {5} maxWidth = {150} maxHeight = {100}>
              {data.pulse ? data.pulse : '--'}
            </Box>
            LEAD MAIN
          </Box>
          <Box textColor = "blue" mb = {3}>
            SpO2%
            <Box textAlign = "left" fontSize = {5} maxWidth = {150} maxHeight = {100}>
              {data.saturation}%
            </Box>
            LEAD OXY
          </Box>
          <Box textColor = "green" mb = {3}>
            BP mmHg
            <Box textAlign = "left" fontSize = {5} maxWidth = {150} maxHeight = {100}>
              {data.pressure}
            </Box>
            SYS/DIA
          </Box>
          RR: {data.breath_rate}/m
        </Section>
        <Section title = "Advanced Data" fontSize = {1.3}>
          <LabeledList>
            <LabeledList.Item label = "AutoECG">
              {data.rhythm}
            </LabeledList.Item>
            <LabeledList.Item label = "TPVR">
              {data.tpvr} N·s·m-5
            </LabeledList.Item>
            <LabeledList.Item label = "MCV">
              {data.mcv} L/m
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
