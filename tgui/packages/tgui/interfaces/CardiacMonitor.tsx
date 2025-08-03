import { useBackend } from "../backend";
import { AnimatedNumber, Blink, Box, LabeledList, Section, Flex, Button} from 'tgui-core/components';
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
  pulse_alarm: number;
  oxygen_alarm: number;
  pressure_alarm: number;
  breath_alarm: number;
  heart_alarm: number;
  muted: boolean;
}

export const CardiacMonitor = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  return (
    <Window width={800} height={715}>
      <Window.Content>
        <Section fontSize = {1.5}>
          <Flex>
            <Flex.Item width="30%">
              <Box textColor = {data.pulse_alarm > 0 ? "#211e1e" : "#ed1c1c"} mb = {1} backgroundColor = {data.pulse_alarm == 2 ? "#ed1c1c" : data.pulse_alarm == 1 ? "yellow" : null}>
                {data.pulse_alarm > 0 ? <Blink time = {100}>ECG BPM</Blink> : "ECG BPM"}
                <Box textAlign = "left" fontSize = {5} maxWidth = {150} maxHeight = {100}>
                  {data.pulse ? <AnimatedNumber value={data.pulse}></AnimatedNumber> : '--'}
                </Box>
                {data.pulse_alarm > 0 ? <Blink time = {300}>LEAD MAIN</Blink> : "LEAD MAIN"}
              </Box>
              <Box textColor = {data.oxygen_alarm > 0 ? "#041b29" : "blue"} mb = {1} backgroundColor = {data.oxygen_alarm == 2 ? "#ed1c1c" : data.oxygen_alarm == 1 ? "yellow" : null}>
              {data.oxygen_alarm > 0 ? <Blink time = {100}>SpO2%</Blink> : "SpO2%"}
                <Box textAlign = "left" fontSize = {5} maxWidth = {150} maxHeight = {100}>
                  <AnimatedNumber value={data.saturation}></AnimatedNumber>%
                </Box>
                {data.oxygen_alarm > 0 ? <Blink time = {300}>LEAD OXY</Blink> : "LEAD OXY"}
              </Box>
              <Box textColor = {data.pressure_alarm > 0 ? "#211e1e" : "green"} mb = {1} backgroundColor = {data.pressure_alarm == 2 ? "#ed1c1c" : data.pressure_alarm == 1 ? "yellow" : null}>
                BP mmHg
                <Box textAlign = "left" fontSize = {5} maxWidth = {150} maxHeight = {100} mr = {1}>
                  <AnimatedNumber value={data.systolic_pressure}></AnimatedNumber>/<AnimatedNumber value={data.diastolic_pressure}></AnimatedNumber><br></br>
                  <Box fontSize = {3} mb = {1}>
                    (<AnimatedNumber value={data.mean_pressure}></AnimatedNumber>)
                  </Box>
                </Box>
                SYS/DIA<br></br>
                MAP
              </Box>
              <Box textColor = {data.breath_alarm > 0 ? "#211e1e" : "white"} backgroundColor = {data.breath_alarm == 2 ? "#ed1c1c" : data.breath_alarm == 1 ? "yellow" : null}>
                RR: <AnimatedNumber value={data.breath_rate}></AnimatedNumber>/m
              </Box>
            </Flex.Item>
            <Flex.Item></Flex.Item>
          </Flex>
        </Section>
        <Section title = "Advanced Data" fontSize = {1.3}>
          <LabeledList>
            <LabeledList.Item label = "AutoECG">
              <Box bold = {data.heart_alarm == 2} textColor = {data.heart_alarm == 2 ? "#ed1c1c" : data.heart_alarm == 1 ? "yellow" : "white"}>
              {data.rhythm}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label = "TPVR">
              <AnimatedNumber value={data.tpvr}></AnimatedNumber> N·s·m-5
            </LabeledList.Item>
            <LabeledList.Item label = "MCV">
              <AnimatedNumber value={data.mcv}></AnimatedNumber> L/m
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title = "Configuration">
          <Button
          color = "yellow"
          tooltip = "Temporarily mutes the alarms on this monitor."
          disabled = {data.muted}
          onClick = {() => act('mute_alarms')}
          >MUTE ALARMS
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
