import { useBackend, useLocalState } from "../backend";
import { LabeledList, Button, ProgressBar, NoticeBox, Section, Divider, NumberInput, Flex } from 'tgui-core/components';
import { formatSiUnit } from "tgui-core/format";
import { Window } from "../layouts";

type InputData = {
  turb1: TurbineData;
  turb2: TurbineData;
}

type TurbineData = {
  rpm: number;
  efficiency: number;
  vibration: string;
  mass_flow: number;
  steam_velocity: number;
  breaks_engaged: boolean;
  inlet_temperature: number;
  inlet_pressure: number;
  exhaust_temperature: number;
  exhaust_pressure: number;
  static_expansion: number;
  real_expansion: number;
  kinetic_delta: number;
  valve_position: number;
}

export const TurbineMonitor = (props: any) => {
  const { act, data } = useBackend<InputData>();
  return (
    <Window width={570} height={570} theme = "ntos">
      <Window.Content fitted>
        <Section title="Turbine 1">
          <LabeledList>
            <LabeledList.Item label="RPM">
              <ProgressBar
                ranges={{
                bad: [3700, Infinity],
                good: [3500, 3700],
                average: [800, 3500],
                teal: [0, 800],
                }}
                minValue = {0}
                maxValue = {4000}
                value={data.turb1.rpm}>
                {data.turb1.rpm}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label = "Efficiency">
              <ProgressBar
                  ranges={{
                  good: [0.85, Infinity],
                  average: [0.4, 0.85],
                  bad: [0, 0.4],
                  }}
                  value={data.turb1.efficiency}>
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Divider></LabeledList.Divider>
          </LabeledList>
              <Flex>
                <Flex.Item mx = {1}>
                  <Section title = "Status">
                    <LabeledList>
                      <LabeledList.Item label="Vibration">
                        {data.turb1.vibration} mm/s
                      </LabeledList.Item>
                      <LabeledList.Item label="Shaft Integrity">
                        {100}%
                      </LabeledList.Item>
                      <LabeledList.Item label="Rotor Integrity">
                        {100}%
                      </LabeledList.Item>
                      <LabeledList.Item label="Static Expansion">
                        {data.turb1.static_expansion * 100}%
                      </LabeledList.Item>
                    </LabeledList>
                  </Section>
                </Flex.Item>
                <Flex.Item mx = {1}>
                  <Section title = "Flow">
                    <LabeledList>
                      <LabeledList.Item label="Energy Balance">
                        {formatSiUnit(data.turb1.kinetic_delta, 1, "W")}
                      </LabeledList.Item>
                      <LabeledList.Item label="Mass Flow">
                        {data.turb1.mass_flow} kg/s
                      </LabeledList.Item>
                      <LabeledList.Item label="Steam Velocity">
                        {data.turb1.steam_velocity} m/s
                      </LabeledList.Item>
                      <LabeledList.Item label="Real Expansion">
                        {data.turb1.real_expansion*100}%
                      </LabeledList.Item>
                    </LabeledList>
                  </Section>
                </Flex.Item>
                <Flex.Item mx = {1}>
                  <Section title = "Thermodynamics">
                    <LabeledList>
                      <LabeledList.Item label="Inlet Temperature">
                        {data.turb1.inlet_temperature} K
                      </LabeledList.Item>
                      <LabeledList.Item label="Inlet Pressure">
                        {data.turb1.inlet_pressure} kPa
                      </LabeledList.Item>
                      <LabeledList.Item label="Exhaust Temperature">
                        {data.turb1.exhaust_temperature} K
                      </LabeledList.Item>
                      <LabeledList.Item label="Exhaust Pressure">
                        {data.turb1.exhaust_pressure} kPa
                      </LabeledList.Item>
                    </LabeledList>
                  </Section>
                </Flex.Item>
              </Flex>
          <Divider/>
          {!data.turb1.breaks_engaged ? null : <NoticeBox warning>EMERGENCY BRAKES ENGAGED</NoticeBox>}
          <Button.Confirm
            confirmContent = "CONFIRM "
            confirmColor = "red"
            textAlign = "center"
            disabled = {data.turb1.breaks_engaged}
            fontSize = {1.5}
            tooltip = "Engages the emergency brakes on that turbine."
            verticalAlignContent = "middle"
            color = {"orange"}
            onClick={() => act('braketurb1')}>
            BRAKE
          </Button.Confirm>
          <Button.Confirm
            confirmContent = "CONFIRM "
            confirmColor = "red"
            textAlign = "center"
            disabled = {data.turb1.valve_position == 0}
            fontSize = {1.5}
            mx = {0.5}
            tooltip = "Shuts down that turbine."
            verticalAlignContent = "middle"
            color = {"yellow"}
            onClick={() => act('tripturb1')}>
            TRIP
          </Button.Confirm>
          <NumberInput
            animated = {1}
            value = {data.turb1.valve_position}
            fontSize = {1.5}
            stepPixelSize = {6}
            minValue = {0}
            maxValue = {100}
            unit = "%"
            onChange = {(_, value) => act('turb1adjust', { entry: value })}
          ></NumberInput>
        </Section>

        <Section title="Turbine 2">
        <LabeledList>
            <LabeledList.Item label="RPM">
              <ProgressBar
                ranges={{
                bad: [3700, Infinity],
                good: [3500, 3700],
                average: [800, 3500],
                teal: [0, 800],
                }}
                minValue = {0}
                maxValue = {4000}
                value={data.turb2.rpm}>
                {data.turb2.rpm}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label = "Efficiency">
              <ProgressBar
                  ranges={{
                  good: [0.85, Infinity],
                  average: [0.4, 0.85],
                  bad: [0, 0.4],
                  }}
                  value={data.turb2.efficiency}>
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Divider></LabeledList.Divider>
          </LabeledList>
              <Flex>
                <Flex.Item mx = {1}>
                  <Section title = "Status">
                    <LabeledList>
                      <LabeledList.Item label="Vibration">
                        {data.turb2.vibration} mm/s
                      </LabeledList.Item>
                      <LabeledList.Item label="Shaft Integrity">
                        {100}%
                      </LabeledList.Item>
                      <LabeledList.Item label="Rotor Integrity">
                        {100}%
                      </LabeledList.Item>
                      <LabeledList.Item label="Static Expansion">
                        {data.turb2.static_expansion * 100}%
                      </LabeledList.Item>
                    </LabeledList>
                  </Section>
                </Flex.Item>
                <Flex.Item mx = {1}>
                  <Section title = "Flow">
                    <LabeledList>
                      <LabeledList.Item label="Energy Balance">
                        {formatSiUnit(data.turb2.kinetic_delta, 1, "W")}
                      </LabeledList.Item>
                      <LabeledList.Item label="Mass Flow">
                        {data.turb2.mass_flow} kg/s
                      </LabeledList.Item>
                      <LabeledList.Item label="Steam Velocity">
                        {data.turb2.steam_velocity} m/s
                      </LabeledList.Item>
                      <LabeledList.Item label="Real Expansion">
                        {data.turb2.real_expansion*100}%
                      </LabeledList.Item>
                    </LabeledList>
                  </Section>
                </Flex.Item>
                <Flex.Item mx = {1}>
                  <Section title = "Thermodynamics">
                    <LabeledList>
                      <LabeledList.Item label="Inlet Temperature">
                        {data.turb2.inlet_temperature} K
                      </LabeledList.Item>
                      <LabeledList.Item label="Inlet Pressure">
                        {data.turb2.inlet_pressure} kPa
                      </LabeledList.Item>
                      <LabeledList.Item label="Exhaust Temperature">
                        {data.turb2.exhaust_temperature} K
                      </LabeledList.Item>
                      <LabeledList.Item label="Exhaust Pressure">
                        {data.turb2.exhaust_pressure} kPa
                      </LabeledList.Item>
                    </LabeledList>
                  </Section>
                </Flex.Item>
              </Flex>
          <Divider/>
          {!data.turb2.breaks_engaged ? null : <NoticeBox warning>EMERGENCY BRAKES ENGAGED</NoticeBox>}
          <Button.Confirm
            confirmContent = "CONFIRM "
            confirmColor = "red"
            textAlign = "center"
            disabled = {data.turb2.breaks_engaged}
            fontSize = {1.5}
            tooltip = "Engages the emergency brakes on that turbine."
            verticalAlignContent = "middle"
            color = {"orange"}
            onClick={() => act('braketurb2')}>
            BRAKE
          </Button.Confirm>
          <Button.Confirm
            confirmContent = "CONFIRM "
            confirmColor = "red"
            textAlign = "center"
            disabled = {data.turb2.valve_position == 0}
            fontSize = {1.5}
            mx = {0.5}
            tooltip = "Shuts down that turbine."
            verticalAlignContent = "middle"
            color = {"yellow"}
            onClick={() => act('tripturb2')}>
            TRIP
          </Button.Confirm>
          <NumberInput
            animated = {1}
            value = {data.turb2.valve_position}
            fontSize = {1.5}
            stepPixelSize = {6}
            minValue = {0}
            maxValue = {100}
            unit = "%"
            onChange = {(_, value) => act('turb2adjust', { entry: value })}
          ></NumberInput>
        </Section>
      </Window.Content>
    </Window>
  );
};
