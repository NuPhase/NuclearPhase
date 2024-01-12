import { useBackend} from "../backend";
import { LabeledList, Box, Section, Flex, ProgressBar } from "../components";
import { formatSiUnit } from "../format";
import { Window } from "../layouts";

type Alarm = {
  content: string;
  alarm_color: string;
  is_bold: boolean;
}

type InputData = {
  alarmlist: Alarm[];
  power_load: number;
  thermal_load: number;
  neutron_rate: number;
  xray_flux: number;
  radiation: number;
  chamber_temperature: number;
  containment_consumption: number;
  containment_temperature: number;
  containment_charge: number;
  moderator_position: number;
  reflector_position: number;
}

export const GeneralReactorMonitor = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  return (
    <Window width = {650} height = {530} theme="ntos">
      <Window.Content>
        <Flex>
          <Flex.Item height={40}>
            <Section title = "Centralized Warning Log"
              fill
              backgroundColor="black">
              {data.alarmlist.map(Alarm => (
                <Box
                  mb = {2}
                  textColor = {Alarm.alarm_color}
                  bold = {Alarm.is_bold}>
                  {Alarm.content}
                </Box>
              ))}
            </Section>
          </Flex.Item>
          <Flex.Item height={20}>
            <Section title = " General Data">
              <LabeledList>
                <LabeledList.Item label = "Total Power Generation">
                  {formatSiUnit(data.power_load, 1, "W")}
                </LabeledList.Item>
                <LabeledList.Item label = "Turbine Energy Flow">
                  {formatSiUnit(data.thermal_load, 1, "W")}
                </LabeledList.Item>
                <LabeledList.Item label = "Neutron Generation Rate">
                  <ProgressBar
                    ranges={{
                    bad: [1.2, Infinity],
                    good: [0.95, 1.05],
                    average: [1.05, 1.2],
                    teal: [0, 0.95],
                    }}
                    minValue = {0}
                    maxValue = {2}
                    value={data.neutron_rate}>
                  {data.neutron_rate*100-100}%
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label = "External Radiation Level">
                  {data.radiation} Sv/hour
                </LabeledList.Item>
                <LabeledList.Item label = "XRay Flux">
                  {data.xray_flux}
                </LabeledList.Item>
                <LabeledList.Item label = "Chamber Temperature">
                  {formatSiUnit(data.chamber_temperature, 1, "K")}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section title = " Containment Data">
              <LabeledList>
                <LabeledList.Item label = "Shield Power Consumption">
                  {formatSiUnit(data.containment_consumption, 1, "W")}
                </LabeledList.Item>
                <LabeledList.Item label = "Shield Temperature">
                  {formatSiUnit(data.containment_temperature, 1, "K")}
                </LabeledList.Item>
                <LabeledList.Item label = "Shield Battery Charge">
                  {data.containment_charge}%
                </LabeledList.Item>
                <LabeledList.Item label = "Moderator Position">
                  {data.moderator_position*100}%
                </LabeledList.Item>
                <LabeledList.Item label = "Reflector Position">
                  {data.reflector_position*100}%
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  )
}
