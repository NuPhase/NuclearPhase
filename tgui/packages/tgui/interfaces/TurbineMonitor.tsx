import { useBackend, useSharedState } from "../backend";
import { Box, Tabs, LabeledList, LabeledControls, RoundGauge, Button, ProgressBar, NoticeBox, Section, Divider, NumberInput, Flex } from 'tgui-core/components';
import { formatSiUnit } from "tgui-core/format";
import { toFixed } from 'tgui-core/math';
import { Window } from "../layouts";

type InputData = {
  turb1: TurbineData;
  turb2: TurbineData;
  sg_inlet_valve: number;
  sg_temp: number;
  sg_pressure: number;
  sg_level: number;
  sg_header_temp: number;
  steam_quality: number;
  condenser_pressure: number;
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
  shaft_integrity: number;
  rotor_integrity: number;
}

const formatPressure = value => {
  if (value < 10000) {
    return toFixed(value) + ' kPa';
  }
  return formatSiUnit(value * 1000, 1, 'Pa');
};

export const TurbineMonitor = (props) => {
  const { act, data } = useBackend<InputData>();
  const [tab, setTab] = useSharedState('turbines', "Turbines");
  return (
    <Window width={570} height={600} theme = "ntos">
      <Window.Content fitted>
    <Flex
      direction={"column"}>
      <Flex.Item
        position="relative"
        mb={1}>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === "Turbines"}
            onClick={() => setTab("Turbines")}>
            Turbines
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === "Steam Loop"}
            onClick={() => setTab("Steam Loop")}>
            Steam Loop
          </Tabs.Tab>
        </Tabs>
      </Flex.Item>
      {tab === "Turbines" && <TurbineTab/>}
      {tab === "Steam Loop" && <SteamTab/>}
    </Flex>
      </Window.Content>
      </Window>
  );
};

const SteamTab = (props) => {
    const { act, data } = useBackend<InputData>();
    return (
        <Box>
          <LabeledList>
            <LabeledList.Item label="SG Inlet Valve">
              <ProgressBar
                ranges={{
                teal: [0, 100],
                }}
                minValue = {0}
                maxValue = {100}
                value={data.sg_inlet_valve}>
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Divider></LabeledList.Divider>
          </LabeledList>
            <LabeledControls>
                <LabeledControls.Item label = "SG Temp">
                    <RoundGauge
                    size={3}
                    value = {data.sg_temp}
                    minValue= {300}
                    maxValue= {600}
                    ranges={{
                        "average": [300, 470],
                        "good": [470, 560],
                        "bad": [560, 600],
                    }}
                    alertAfter={560}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
                <LabeledControls.Item label = "SG Pressure">
                    <RoundGauge
                    size={3}
                    value = {data.sg_pressure}
                    format = {formatPressure}
                    minValue= {0}
                    maxValue= {9000}
                    ranges={{
                        "average": [0, 6500],
                        "good": [6500, 7500],
                        "bad": [7500, 9000],
                    }}
                    alertAfter={9000}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
                <LabeledControls.Item label = "SG Level">
                    <RoundGauge
                    size={3}
                    value = {data.sg_level}
                    minValue= {-5}
                    maxValue= {5}
                    alertBefore={-3}
                    alertAfter={3}
                    ranges={{
                        "bad": [-5, 1],
                        "good": [-1, 1],
                        "average": [1, 5],
                    }}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
                <LabeledControls.Item label = "SG Header Temp">
                    <RoundGauge
                    size={3}
                    value = {data.sg_header_temp}
                    minValue= {500}
                    maxValue= {2800}
                    ranges={{
                        "bad": [500, 700],
                        "good": [700, 2800],
                    }}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
            </LabeledControls>
            <LabeledControls>
                <LabeledControls.Item label = "Steam Quality">
                    <RoundGauge
                    size={3}
                    value = {data.steam_quality}
                    minValue= {80}
                    maxValue= {100}
                    ranges={{
                        "bad": [80, 98],
                        "good": [98, 100],
                    }}
                    alertBefore={98}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
                <LabeledControls.Item label = "Condenser Pressure">
                    <RoundGauge
                    size={3}
                    value = {data.condenser_pressure}
                    minValue= {0}
                    maxValue= {200}
                    format = {formatPressure}
                    ranges={{
                        "good": [0, 150],
                        "bad": [150, 200],
                    }}
                    alertAfter={150}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
            </LabeledControls>
        </Box>
    );
};

export const TurbineTab = (props) => {
  const { act, data } = useBackend<InputData>();
  return (
      <Box>
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
                        {Math.round(data.turb1.shaft_integrity)}%
                      </LabeledList.Item>
                      <LabeledList.Item label="Rotor Integrity">
                        {Math.round(data.turb1.rotor_integrity)}%
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
            animated = {true}
            value = {data.turb1.valve_position}
            fontSize = {1.5}
            stepPixelSize = {6}
            step = {0.1}
            minValue = {0}
            maxValue = {100}
            unit = "%"
            onChange = {(value) => act('turb1adjust', { entry: value })}
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
                        {Math.round(data.turb2.shaft_integrity)}%
                      </LabeledList.Item>
                      <LabeledList.Item label="Rotor Integrity">
                        {Math.round(data.turb2.rotor_integrity)}%
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
            animated = {true}
            value = {data.turb2.valve_position}
            fontSize = {1.5}
            stepPixelSize = {6}
            step = {0.1}
            minValue = {0}
            maxValue = {100}
            unit = "%"
            onChange = {(value) => act('turb2adjust', { entry: value })}
          ></NumberInput>
        </Section>
      </Box>
  );
};
