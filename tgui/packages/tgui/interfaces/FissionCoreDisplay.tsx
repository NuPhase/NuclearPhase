import { toFixed } from 'tgui-core/math';
import { Icon, Box, Section, Tabs, Stack, Tooltip, ProgressBar, LabeledList, Divider, AnimatedNumber, Slider, Button } from 'tgui-core/components';
import { formatSiUnit } from "tgui-core/format";
import { useBackend, useSharedState } from '../backend';
import { Window } from 'tgui/layouts';

type Rod = {
  x: number;
  y: number;
  temperature: number;
  insertion: number; // 0-1
  has_rod: boolean;
}

type InputData = {
  rods: Rod[];
  tempAverage: number;
  tempHighest: number;
  coreFlux: number;
  targetFlux: number;
  autoEnabled: boolean;
  reactorPeriod: number;
  targetPeriod: number;
  equivRod: number;
  thermalPower: number;
  dopplerFactor: number;
  recircFlow: number;
  vesselTemperature: number;
  vesselPressure: number;
  vesselLevel: number;
  fuelTemperature: number;
  fuelPressure: number;
  recircSpeed: number;
  recircSetpoint: number;
  inletTemperature: number;
  inletFlow: number;
}

const lerp = (a, b, t) => a + (b - a) * t;

const lerpHex = (hex1, hex2, t) => {
  const r1 = parseInt(hex1.slice(1, 3), 16);
  const g1 = parseInt(hex1.slice(3, 5), 16);
  const b1 = parseInt(hex1.slice(5, 7), 16);
  const r2 = parseInt(hex2.slice(1, 3), 16);
  const g2 = parseInt(hex2.slice(3, 5), 16);
  const b2 = parseInt(hex2.slice(5, 7), 16);

  const r = Math.round(lerp(r1, r2, t));
  const g = Math.round(lerp(g1, g2, t));
  const b = Math.round(lerp(b1, b2, t));

  return `#${((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1)}`;
};

const getRodColor = (value) => {
  const min = 0.85;
  const mid = 1.02;
  const max = 1.06;

  const cold  = "#1c6daf";
  const neutral = "#9E9E9E";
  const hot   = "#ff3c00";

  if (value <= min) return cold;
  if (value >= max) return hot;

  if (value <= mid) {
    const t = (value - min) / (mid - min);
    return lerpHex(cold, neutral, t);
  } else {
    const t = (value - mid) / (max - mid);
    return lerpHex(neutral, hot, t);
  }
};

const getInsertionColor = value => {
    if (value == 1) {
    return "green";
    }
    if (value == 0) {
    return "red";
    }
    return "gray";
};

const formatFlux = (value: number) => {
    value = value * 172061164571428571.0;
    return value.toExponential(3) + '/cm³'
};

const formatReactivity = (value: number) => {
    value = value * 1337;
    return value.toExponential(3) + '¢'
};


const getInsertionPercentString = value => {
   return toFixed(value * 100, 1) + '%';
};

export const FissionCoreDisplay = (props) => {
    const { act, data } = useBackend<InputData>();
    const [mainTab, setMainTab] = useSharedState('main', "Coordinates");
    const [sideTab, setSideTab] = useSharedState('side', "Main");
    return (
        <Window width={1100} height={800}>
            <Window.Content>
                <Stack>
                    <Stack.Item width = {600}>
                        <Section>
                            <Tabs>
                            <Tabs.Tab
                                key = "Coordinates"
                                selected={mainTab === "Coordinates"}
                                onClick={() => setMainTab("Coordinates")}>
                                Coordinates
                            </Tabs.Tab>
                            <Tabs.Tab
                                key = "Temperature"
                                selected={mainTab === "Temperature"}
                                onClick={() => setMainTab("Temperature")}>
                                Temperature
                            </Tabs.Tab>
                            <Tabs.Tab
                                key = "Insertion"
                                selected={mainTab === "Insertion"}
                                onClick={() => setMainTab("Insertion")}>
                                Insertion
                            </Tabs.Tab>
                            </Tabs>
                        </Section>
                        {mainTab === "Coordinates" && <CoreDisplayCoords
                            rods = {data.rods}
                        ></CoreDisplayCoords>}
                        {mainTab === "Temperature" && <CoreDisplayTemperature
                            rods = {data.rods}
                            tempAverage = {data.tempAverage}
                        ></CoreDisplayTemperature>}
                        {mainTab === "Insertion" && <CoreDisplayInsertion
                            rods = {data.rods}
                        ></CoreDisplayInsertion>}
                    </Stack.Item>
                    <Stack.Item width = {200}>
                        <Section>
                            <Tabs>
                            <Tabs.Tab
                                key = "Main"
                                selected={sideTab === "Main"}
                                onClick={() => setSideTab("Main")}>
                                Main
                            </Tabs.Tab>
                            <Tabs.Tab
                                key = "Reactivity"
                                selected={sideTab === "Reactivity"}
                                onClick={() => setSideTab("Reactivity")}>
                                Reactivity
                            </Tabs.Tab>
                            <Tabs.Tab
                                key = "Auto"
                                selected={sideTab === "Auto"}
                                onClick={() => setSideTab("Auto")}>
                                Auto
                            </Tabs.Tab>
                            <Tabs.Tab
                                key = "Manual"
                                selected={sideTab === "Manual"}
                                onClick={() => setSideTab("Manual")}>
                                Manual
                            </Tabs.Tab>
                            </Tabs>
                        </Section>
                        <Section fill height={58}>
                            {sideTab === "Main" && <SideDisplayMain
                            thermalPower = {data.thermalPower}
                            reactorPeriod = {Math.round(data.reactorPeriod)}
                            neutronFlux = {data.coreFlux}
                            averageTemp = {data.tempAverage}
                            highestTemp = {data.tempHighest}
                            recircFlow = {data.recircFlow}
                            rodPosition = {data.equivRod * 100}
                            vesselTemp = {data.vesselTemperature}
                            vesselPressure = {data.vesselPressure}
                            vesselLevel = {data.vesselLevel}
                            fuelTemp = {data.fuelTemperature}
                            fuelPressure = {data.fuelPressure * 0.001}
                            circSpeed = {data.recircSpeed}
                            circSetpoint = {data.recircSetpoint}
                            inletTemp = {data.inletTemperature}
                            inletFlow = {data.inletFlow}
                        ></SideDisplayMain>}
                        {sideTab === "Reactivity" && <SideDisplayReactivity
                            thermalPower = {data.thermalPower}
                            reactorPeriod = {Math.round(data.reactorPeriod)}
                            neutronFlux = {data.coreFlux}
                            recircFlow = {data.recircFlow}
                            rodPosition = {data.equivRod * 100}
                            dopplerFactor = {data.dopplerFactor}
                        ></SideDisplayReactivity>}
                        {sideTab === "Auto" && <SideDisplayAuto
                            thermalPower = {data.thermalPower}
                            reactorPeriod = {Math.round(data.reactorPeriod)}
                            neutronFlux = {data.coreFlux}
                            recircFlow = {data.recircFlow}
                            rodPosition = {data.equivRod * 100}
                            fluxTarget = {data.targetFlux}
                            autoEnabled = {data.autoEnabled}
                            targetPeriod = {data.targetPeriod}
                        ></SideDisplayAuto>}
                        {sideTab === "Manual" && <SideDisplayManual
                            thermalPower = {data.thermalPower}
                            reactorPeriod = {Math.round(data.reactorPeriod)}
                            neutronFlux = {data.coreFlux}
                            recircFlow = {data.recircFlow}
                            rodPosition = {data.equivRod * 100}
                        ></SideDisplayManual>}
                        </Section>
                    </Stack.Item>
                </Stack>

            </Window.Content>
        </Window>
  );
};

const SideDisplayMain = (props) => {
    const { act } = useBackend<InputData>();
    const { thermalPower, reactorPeriod, neutronFlux, averageTemp, highestTemp, recircFlow, rodPosition, vesselTemp, vesselPressure, vesselLevel, fuelTemp, fuelPressure, circSpeed, circSetpoint, inletTemp, inletFlow } = props;
    return (
    <Box>
        <Divider></Divider>
        <Box textAlign={"center"}>Core Monitoring</Box>
        <LabeledList>
            <LabeledList.Item label="Thermal Power">
                <ProgressBar
                    value={thermalPower}
                    minValue={0}
                    maxValue={1000}
                    ranges={{
                                "good": [0, 100],
                                "average": [100, 1050],
                                "bad": [1050, Infinity],
                    }}
                    >{toFixed(thermalPower)}MW
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Reactor Period">
                {reactorPeriod == 0 ? "∞" : <AnimatedNumber value={reactorPeriod}></AnimatedNumber>}s
            </LabeledList.Item>
            <LabeledList.Item label="Core Flux">
                {formatFlux(neutronFlux)}
            </LabeledList.Item>
            <LabeledList.Item label="Average Temp">
                {toFixed(averageTemp, 1)}K
            </LabeledList.Item>
            <LabeledList.Item label="Highest Temp">
                {toFixed(highestTemp, 1)}K
            </LabeledList.Item>
            <LabeledList.Item label="Circulation">
                {toFixed(recircFlow, 1)}t/s
            </LabeledList.Item>
            <LabeledList.Item label="Rod Position">
                {toFixed(rodPosition, 1)}%
            </LabeledList.Item>
        </LabeledList>
        <Divider></Divider>
        <Box textAlign={"center"}>Vessel Data</Box>
        <LabeledList>
            <LabeledList.Item label="Vessel Temp">
                <ProgressBar
                    value={vesselTemp}
                    minValue={900}
                    maxValue={2900}
                    ranges={{
                                "teal": [900, 1500],
                                "good": [1500, 2500],
                                "average": [2500, 2750],
                                "bad": [2750, Infinity],
                    }}
                    >{toFixed(vesselTemp,1)}K
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Vessel Pressure">
                <ProgressBar
                    value={vesselPressure}
                    minValue={100}
                    maxValue={1100}
                    ranges={{
                                "good": [100, 300],
                                "average": [300, 1000],
                                "bad": [1000, Infinity],
                    }}
                    >{toFixed(vesselPressure)}kPa
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Vessel Level">
                <ProgressBar
                    value={vesselLevel}
                    minValue={0}
                    maxValue={100}
                    ranges={{
                                "bad": [0, 50],
                                "good": [50, 90],
                                "average": [90, 100],
                    }}
                    >{toFixed(vesselLevel,1)}%
                </ProgressBar>
            </LabeledList.Item>
        </LabeledList>
        <Divider></Divider>
        <Box textAlign={"center"}>Fuel Data</Box>
        <LabeledList>
            <LabeledList.Item label="Fuel Temp">
                <ProgressBar
                    value={fuelTemp}
                    minValue={900}
                    maxValue={3500}
                    ranges={{
                                "average": [1000, 2700],
                                "good": [2700, 3300],
                                "bad": [3300, Infinity],
                    }}
                    >{toFixed(fuelTemp,1)}K
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Fuel Pressure">
                <ProgressBar
                    value={fuelPressure}
                    minValue={0.1}
                    maxValue={20}
                    ranges={{
                                "average": [0.1, 1],
                                "good": [1, 15],
                                "bad": [15, 20],
                    }}
                    >{toFixed(fuelPressure)}MPa
                </ProgressBar>
            </LabeledList.Item>
        </LabeledList>
        <Divider></Divider>
        <Box textAlign={"center"}>Circulation Data</Box>
        <LabeledList>
            <LabeledList.Item label="Recirc Speed">
                <ProgressBar
                    value={circSpeed}
                    minValue={0}
                    maxValue={100}
                    ranges={{
                                "bad": [0, 15],
                                "good": [15, 100]
                    }}
                    >{toFixed(circSpeed)}%
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label ="Recirc target">
                <Slider
                    animated
                    color = "yellow"
                    value = {circSetpoint}
                    unit = "%"
                    onChange = {(_, value) => act('change_target_circ', { target_circ: (value) })}
                    minValue = {0}
                    maxValue = {100}>
                </Slider>
            </LabeledList.Item>
            <LabeledList.Item label="Inlet Temp">
                {toFixed(inletTemp, 1)}K
            </LabeledList.Item>
            <LabeledList.Item label="Inlet Flow">
                {toFixed(inletFlow)}kg/s
            </LabeledList.Item>
        </LabeledList>
    </Box>);
};

const SideDisplayReactivity = (props) => {
    const { act } = useBackend<InputData>();
    const { thermalPower, reactorPeriod, neutronFlux, recircFlow, rodPosition, dopplerFactor } = props;
    return (
    <Box>
        <Divider></Divider>
        <Box textAlign={"center"}>Core Monitoring</Box>
        <LabeledList>
            <LabeledList.Item label="Thermal Power">
                <ProgressBar
                    value={thermalPower}
                    minValue={0}
                    maxValue={1000}
                    ranges={{
                                "good": [0, 100],
                                "average": [100, 1050],
                                "bad": [1050, Infinity],
                    }}
                    >{toFixed(thermalPower)}MW
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Reactor Period">
                {reactorPeriod == 0 ? "∞" : <AnimatedNumber value={reactorPeriod}></AnimatedNumber>}s
            </LabeledList.Item>
            <LabeledList.Item label="Core Flux">
                {formatFlux(neutronFlux)}
            </LabeledList.Item>
            <LabeledList.Item label="Circulation">
                {toFixed(recircFlow, 1)}t/s
            </LabeledList.Item>
            <LabeledList.Item label="Rod Position">
                {toFixed(rodPosition, 1)}%
            </LabeledList.Item>
        </LabeledList>
        <Divider></Divider>
        <Box textAlign={"center"}>Reactivity Worth</Box>
        <LabeledList>
            <LabeledList.Item label="Rod Worth">
                {formatReactivity(rodPosition)}
            </LabeledList.Item>
            <LabeledList.Item label="Doppler Worth">
                {formatReactivity(dopplerFactor)}
            </LabeledList.Item>
        </LabeledList>
    </Box>);
};

const SideDisplayAuto = (props) => {
    const { act } = useBackend<InputData>();
    const { thermalPower, reactorPeriod, neutronFlux, recircFlow, rodPosition, fluxTarget, autoEnabled, targetPeriod } = props;
    return (
    <Box>
        <Divider></Divider>
        <Box textAlign={"center"}>Core Monitoring</Box>
        <LabeledList>
            <LabeledList.Item label="Thermal Power">
                <ProgressBar
                    value={thermalPower}
                    minValue={0}
                    maxValue={1000}
                    ranges={{
                                "good": [0, 100],
                                "average": [100, 1050],
                                "bad": [1050, Infinity],
                    }}
                    >{toFixed(thermalPower)}MW
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Reactor Period">
                {reactorPeriod == 0 ? "∞" : <AnimatedNumber value={reactorPeriod}></AnimatedNumber>}s
            </LabeledList.Item>
            <LabeledList.Item label="Core Flux">
                {formatFlux(neutronFlux)}
            </LabeledList.Item>
            <LabeledList.Item label="Circulation">
                {toFixed(recircFlow, 1)}t/s
            </LabeledList.Item>
            <LabeledList.Item label="Rod Position">
                {toFixed(rodPosition, 1)}%
            </LabeledList.Item>
        </LabeledList>
        <Divider></Divider>
        <Box textAlign={"center"}>Auto Setpoints</Box>
        <LabeledList>
            <LabeledList.Item label="Auto Enabled">
                <Button
                color = {autoEnabled ? "red" : "green"}
                onClick={() => act('switch_auto')}
                >{autoEnabled ? "Yes" : "No"}</Button>
            </LabeledList.Item>
            <LabeledList.Item label="Flux Target">
                <Slider
                    animated
                    color = "yellow"
                    value = {fluxTarget * 172061164571428571.0}
                    onChange = {(_, value) => act('change_target_flux', { target_flux: (value/172061164571428571.0) })}
                    minValue = {0}
                    maxValue = {2500000000000}>
                {formatFlux(fluxTarget)}</Slider>
            </LabeledList.Item>
            <LabeledList.Item label="Target Period">
                {toFixed(targetPeriod)}s
            </LabeledList.Item>
        </LabeledList>
    </Box>);
};

const SideDisplayManual = (props) => {
    const { act } = useBackend<InputData>();
    const { thermalPower, reactorPeriod, neutronFlux, recircFlow, rodPosition, fluxTarget, autoEnabled, targetPeriod } = props;
    return (
    <Box>
        <Divider></Divider>
        <Box textAlign={"center"}>Core Monitoring</Box>
        <LabeledList>
            <LabeledList.Item label="Thermal Power">
                <ProgressBar
                    value={thermalPower}
                    minValue={0}
                    maxValue={1000}
                    ranges={{
                                "good": [0, 100],
                                "average": [100, 1050],
                                "bad": [1050, Infinity],
                    }}
                    >{toFixed(thermalPower)}MW
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Reactor Period">
                {reactorPeriod == 0 ? "∞" : <AnimatedNumber value={reactorPeriod}></AnimatedNumber>}s
            </LabeledList.Item>
            <LabeledList.Item label="Core Flux">
                {formatFlux(neutronFlux)}
            </LabeledList.Item>
            <LabeledList.Item label="Circulation">
                {toFixed(recircFlow, 1)}t/s
            </LabeledList.Item>
            <LabeledList.Item label="Rod Position">
                {toFixed(rodPosition, 1)}%
            </LabeledList.Item>
        </LabeledList>
        <Divider></Divider>
        <Box textAlign={"center"}>All Rod Motion</Box>
        <LabeledList>
            <LabeledList.Item label="Withdraw">
                <Button
                color = "red"
                onClick={() => act('big_notch_up')}
                >1%</Button>
                <Button
                color = "red"
                onClick={() => act('notch_up')}
                >0.1%</Button>
            </LabeledList.Item>
            <LabeledList.Item label="Insert">
                <Button
                color = "green"
                onClick={() => act('big_notch_down')}
                >1%</Button>
                <Button
                color = "green"
                onClick={() => act('notch_down')}
                >0.1%</Button>
            </LabeledList.Item>
        </LabeledList>
    </Box>);
};


const CoreDisplayTemperature = (props) => {
    const { rods, tempAverage } = props;
    return (
    <Box>
        {rods.map(rod => (
            <Tooltip content={getInsertionPercentString(rod.insertion)}>
            <Box
                position = "absolute"
                bottom = {rod.y*2}
                left = {rod.x*4}>
                    <Icon
                    name = "circle"
                    size = {4}
                    color={getRodColor(rod.temperature / tempAverage)}
                    ></Icon>
                <Box position = "absolute" textAlign = {"center"} bottom = {1.5} left = {0.3} fontSize = {1.1}>{toFixed(rod.temperature)}K</Box>
            </Box>
            </Tooltip>
        ))}
    </Box>);
};

const CoreDisplayCoords = (props) => {
    const { rods } = props;
    return (
    <Box>
        {rods.map(rod => (
            <Box
                position = "absolute"
                bottom = {rod.y*2}
                left = {rod.x*4}>
                    <Icon
                    name = "circle"
                    size = {4}
                    color="gray"
                    ></Icon>
                <Box position = "absolute" textAlign = {"center"} bottom = {1.5} left = {0.3} fontSize = {1.1}>{rod.x}|{rod.y}</Box>
            </Box>
        ))}
    </Box>);
};

const CoreDisplayInsertion = (props) => {
    const { rods } = props;
    return (
    <Box>
        {rods.map(rod => (
            <Box
                position = "absolute"
                bottom = {rod.y*2}
                left = {rod.x*4}>
                    <Icon
                    name = "circle"
                    size = {4}
                    color={getInsertionColor(rod.insertion)}
                    ></Icon>
                <Box position = "absolute" textAlign = {"center"} bottom = {1.5} left = {0.3} fontSize = {1}>{toFixed(rod.insertion*100, 1)}%</Box>
            </Box>
        ))}
    </Box>);
};