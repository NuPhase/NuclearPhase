import { toFixed } from 'tgui-core/math';
import { useBackend, useSharedState } from '../backend';
import { LabeledList, Box, Section, Flex, ProgressBar, BlockQuote, Chart, Icon, Tabs, Stack, Divider } from 'tgui-core/components';
import { formatSiUnit } from "tgui-core/format";
import { Window } from "../layouts";

type Log = {
  content: string;
  color: string;
  is_bold: boolean;
}

type Graphs = {
  thermal_power: number[];
  field_energy: number[];
  energy_loss: number[];
};

type ReactionFraction = {
  name: string;
  energyFraction: number;
  massFraction: number;
};

type InputData = {
  loglist: Log[];
  blanket_integrity: number;
  divertor_integrity: number;
  magnet_integrity: number;
  structure_integrity: number;
  fusion_mass_flux: number;
  temperature: number;
  plasma_instability: number;
  projected_tdelta: number;
  laser_total_charge: number;
  laser_charge_percent: number;
  laser_omode: string;
  laser_nmode: string;
  fractions: ReactionFraction[];
  graphs: Graphs;
}

export const MaintenanceReactorMonitor = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>();
  const thermalPowerData = data.graphs.thermal_power.map((value, i) => [i, value]);
  const maxPowerValue = Math.max(0, ...data.graphs.thermal_power);
  const fieldPowerData = data.graphs.field_energy.map((value, i) => [i, value]);
  const energyLossData = data.graphs.energy_loss.map((value, i) => [i, value]);
  const maxFieldPowerValue = Math.max(0, ...data.graphs.field_energy);
  const [bottomTab, setBottomTab] = useSharedState('bottom', "Fusion Map");
  return (
    <Window width = {900} height = {530} theme="ntos">
      <Window.Content>
        <Flex>
          <Flex.Item height={40} width="30%">
            <Section title = "Message Log"
              fill
              scrollable
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
              <Tabs>
                <Tabs.Tab
                  key = "Fusion Map"
                  selected={bottomTab === "Fusion Map"}
                  onClick={() => setBottomTab("Fusion Map")}>
                  Fusion Map
                </Tabs.Tab>
                <Tabs.Tab
                  key = "Fusion Stats"
                  selected={bottomTab === "Fusion Stats"}
                  onClick={() => setBottomTab("Fusion Stats")}>
                  Fusion Stats
                </Tabs.Tab>
                <Tabs.Tab
                  key = "Laser Data"
                  selected={bottomTab === "Laser Data"}
                  onClick={() => setBottomTab("Laser Data")}>
                  Laser Data
                </Tabs.Tab>
                <Tabs.Tab
                  key = "Fuel Data"
                  selected={bottomTab === "Fuel Data"}
                  onClick={() => setBottomTab("Fuel Data")}>
                  Fuel Data
                </Tabs.Tab>
              </Tabs>
            <Section>
              {bottomTab == "Fusion Map" && <BottomDisplayGraph></BottomDisplayGraph>}
              {bottomTab == "Fusion Stats" && <BottomDisplayStats></BottomDisplayStats>}
              {bottomTab == "Laser Data" && <BottomDisplayLasers></BottomDisplayLasers>}
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  )
}

const BottomDisplayGraph = (props) => {
    const { act, data } = useBackend<InputData>();
    const fieldPowerData = data.graphs.field_energy.map((value, i) => [i, value]);
    const energyLossData = data.graphs.energy_loss.map((value, i) => [i, value]);
    const maxFieldPowerValue = Math.max(0, ...data.graphs.field_energy);
    return (
    <Box height="200px" position="relative" overflow="visible">
                <Box
                  position = "absolute"
                  bottom={`${(data.graphs.field_energy[Math.round((data.temperature-90000000)/1000000)]/maxFieldPowerValue) * 100}%`}
                  left={`${(Math.round((data.temperature-90000000)/1000000) / (data.graphs.field_energy.length - 1)) * 100}%`}
                  style={{
                    transform: 'translate(-50%, 50%)',
                    pointerEvents: 'none',
                  }}
                  >
                  <Icon
                  name="vector-square"
                  size={1.5}
                  color="green"
                  ></Icon>
                </Box>
                <Chart.Line
                fillPositionedParent
                p={1}
                data={fieldPowerData}
                rangeX={[0, fieldPowerData.length - 1]}
                rangeY={[0, maxFieldPowerValue]}
                strokeColor="rgb(231, 220, 55)"
                />
                <Chart.Line
                fillPositionedParent
                p={1}
                data={energyLossData}
                rangeX={[0, energyLossData.length - 1]}
                rangeY={[0, maxFieldPowerValue]}
                strokeColor="rgb(231, 55, 55)"
                fillColor="rgba(185, 43, 43, 0.53)"
                />
              </Box>
)};

const BottomDisplayStats = (props) => {
    const { act, data } = useBackend<InputData>();
    return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Fuel Usage">
          {toFixed(data.fusion_mass_flux, 2)}mg/s | {toFixed(data.fusion_mass_flux/1000*3600)}g/h
        </LabeledList.Item>
        <LabeledList.Item label="Temperature">
          {toFixed(data.temperature/1000000, 2)}MK
        </LabeledList.Item>
        <LabeledList.Item label="Instability">
          <ProgressBar
          value={data.plasma_instability}
          minValue={0}
          maxValue={100}
          ranges={{
            bad: [50, 100],
            average: [20, 50],
            teal: [0, 20]
          }}
          ></ProgressBar>
        </LabeledList.Item>
      </LabeledList>
      <Divider></Divider>
      <Stack>
        <Stack.Item width="50%">
          Energy Fractions
          <Divider></Divider>
          <LabeledList>
            {data.fractions.map((ReactionFraction) => (
              <LabeledList.Item label={ReactionFraction.name}>
                <ProgressBar
                value={ReactionFraction.energyFraction*100}
                minValue={0}
                maxValue={100}>
                  {toFixed(ReactionFraction.energyFraction * 100) + '%'}
                </ProgressBar>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Stack.Item>
        <Stack.Item width="50%">
          Mass Fractions
          <Divider></Divider>
          <LabeledList>
            {data.fractions.map((ReactionFraction) => (
              <LabeledList.Item label={ReactionFraction.name}>
                <ProgressBar
                value={ReactionFraction.massFraction*100}
                minValue={0}
                maxValue={100}
                >
                  {toFixed(ReactionFraction.massFraction * 100) + '%'}
                </ProgressBar>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Box>
)};

const BottomDisplayLasers = (props) => {
    const { act, data } = useBackend<InputData>();
    return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="Charge">
          <ProgressBar
          value={data.laser_charge_percent}
          minValue={0}
          maxValue={100}
          ></ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Charge">
          {formatSiUnit(data.laser_total_charge, 0, "J")}
        </LabeledList.Item>
        <LabeledList.Item label="K After Ignition">
          {formatSiUnit(data.projected_tdelta + data.temperature, 0, "K")}
        </LabeledList.Item>
        <LabeledList.Divider></LabeledList.Divider>
        <LabeledList.Item label="Heating Mode">
          {data.laser_omode}
        </LabeledList.Item>
        <LabeledList.Item label="Heating Mode">
          {data.laser_nmode}
        </LabeledList.Item>
      </LabeledList>
    </Box>
)};