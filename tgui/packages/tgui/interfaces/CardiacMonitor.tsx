import { useBackend, useLocalState } from "../backend";
import { AnimatedNumber, Box, LabeledList, ProgressBar, Section, Tabs } from "../components";
import { Window } from "../layouts";

type InputData = {
  name: string;
  status: string;
  pulse: number;
  systolic_pressure: number;
  diastolic_pressure: number;
  mean_pressure: number;
  saturation: number;
  rhythm: string;
  breath_rate: number;
  tpvr: number;
  mcv: number;
}

export const CardiacMonitor = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  return (
    <Window width={800} height={680}>
      <Window.Content>
        <Section fontSize = {1.5}>
          <Box textColor = "red" mb = {3}>
            ECG BPM
            <Box textAlign = "left" fontSize = {5} maxWidth = {150} maxHeight = {100}>
              {data.pulse ? <AnimatedNumber value={data.pulse}></AnimatedNumber> : '--'}
            </Box>
            LEAD MAIN
          </Box>
          <Box textColor = "blue" mb = {3}>
            SpO2%
            <Box textAlign = "left" fontSize = {5} maxWidth = {150} maxHeight = {100}>
              <AnimatedNumber value={data.saturation}></AnimatedNumber>%
            </Box>
            LEAD OXY
          </Box>
          <Box textColor = "green" mb = {3}>
            BP mmHg
            <Box textAlign = "left" fontSize = {5} maxWidth = {150} maxHeight = {100}>
              <AnimatedNumber value={data.systolic_pressure}></AnimatedNumber>/<AnimatedNumber value={data.diastolic_pressure}></AnimatedNumber><br></br>
              <Box fontSize = {3} mb = {1}>
                (<AnimatedNumber value={data.mean_pressure}></AnimatedNumber>)
              </Box>
            </Box>
            SYS/DIA<br></br>
            MAP
          </Box>
          RR: <AnimatedNumber value={data.breath_rate}></AnimatedNumber>/m
        </Section>
        <Section title = "Advanced Data" fontSize = {1.3}>
          <LabeledList>
            <LabeledList.Item label = "AutoECG">
              {data.rhythm}
            </LabeledList.Item>
            <LabeledList.Item label = "TPVR">
              <AnimatedNumber value={data.tpvr}></AnimatedNumber> N·s·m-5
            </LabeledList.Item>
            <LabeledList.Item label = "MCV">
              <AnimatedNumber value={data.mcv}></AnimatedNumber> L/m
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
