import { sortBy } from 'es-toolkit';
import { useState } from 'react';
import { toFixed } from 'tgui-core/math';
import { formatSiUnit } from "tgui-core/format";
import {
  BlockQuote,
  LabeledList,
  ProgressBar,
  Slider,
  RoundGauge,
  LabeledControls,
  Section,
  Box,
  Tabs,
} from 'tgui-core/components';

import { useBackend, useSharedState } from '../backend';
import { Window } from '../layouts';

const formatPower = value => {
  return formatSiUnit(value, 1, 'W');
};

const formatMass = value => {
    if (value < 0.001) {
    return toFixed(value*1000000) + 'mg';
    }
    if (value < 1) {
    return toFixed(value*1000) + 'g';
    }
    if (value < 1000) {
    return toFixed(value) + 'kg';
    }
    return toFixed(value*0.001) + 't';
};

const formatPressure = value => {
  if (value < 10000) {
    return toFixed(value) + ' kPa';
  }
  return formatSiUnit(value * 1000, 1, 'Pa');
};

type Data = {
  actualRodPosition: number;
  targetRodPosition: number;
  srm: number;
  neutronK: number;
  fastFraction: number;
  fuelTemperature: number;
  fuelPressure: number;
  fuelComp: Gas[];
  fuelTotal: number;
  thermalPower: number;
};
type Gas = {
  name: string;
  color: string;
  amount: number;
  mass: number; //kg
}

export const ResearchReactor = (props) => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useSharedState('reactor', "Reactor");

  return (
    <Window title="Research Reactor" width={500} height={550}>
      <Window.Content scrollable>
        <Section>
            <Tabs.Tab
                key = "Reactor"
                selected={tab === "Reactor"}
                onClick={() => setTab("Reactor")}>
                Tab Test
            </Tabs.Tab>
            <Tabs.Tab
                key = "Fuel"
                selected={tab === "Fuel"}
                onClick={() => setTab("Fuel")}>
                Tab two
            </Tabs.Tab>
        </Section>
        <Section>
            {tab === "Reactor" && <Reactor/>}
            {tab === "Fuel" && <Fuel
                fuelTemperature = {data.fuelTemperature}
                fuelPressure = {data.fuelPressure}
                gases = {data.fuelComp}
                fuelTotal = {data.fuelTotal}
            />}
        </Section>

      </Window.Content>
    </Window>
  );
};

const Reactor = (props) => {
    const { act, data } = useBackend<Data>();
    return (
        <Box>
            <ProgressBar
                color="red"
                value={data.actualRodPosition*100}
                minValue={0}
                maxValue={100}>
            </ProgressBar>
            <Slider
                animated
                color = "yellow"
                value = {data.targetRodPosition*100}
                stepPixelSize = {1}
                step = {0.1}
                unit = "%"
                onChange = {(_, value) => act('change_target_rod', { target_rod: (value*0.01) })}
                minValue = {0}
                maxValue = {100}>
            </Slider>
            <LabeledControls>
                <LabeledControls.Item label = "Core Temp">
                    <RoundGauge
                    size={2}
                    value = {data.fuelTemperature}
                    minValue= {20}
                    maxValue= {900}
                    ranges={{
                        "good": [20, 100],
                        "average": [100, 600],
                        "bad": [600, 900],
                    }}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
                <LabeledControls.Item label = "K">
                    <RoundGauge
                    size={2}
                    value = {data.neutronK}
                    minValue= {0.9}
                    maxValue= {1.1}
                    alertAfter={1.3}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
                <LabeledControls.Item label = "Fast Fraction">
                    <RoundGauge
                    size={2}
                    value = {data.fastFraction*100}
                    minValue= {0}
                    maxValue= {100}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
                <LabeledControls.Item label = "Thermal Power">
                    <RoundGauge
                    size={2}
                    value = {data.thermalPower}
                    minValue= {0}
                    maxValue= {10000000}
                    format = {formatPower}
                    alertAfter={10000000}
                    ranges={{
                        "good": [0, 1000000],
                        "average": [1000000, 5000000],
                        "bad": [5000000, 10000000],
                    }}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
            </LabeledControls>
            <LabeledControls>
                <LabeledControls.Item label = "SRM">
                    <RoundGauge
                    size={2}
                    value = {data.srm}
                    minValue= {0}
                    maxValue= {3000}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
            </LabeledControls>
        </Box>

    );
};

const Fuel = (props) => {
    const { fuelTemperature, fuelPressure, gases, fuelTotal } = props;
    const gasMaxAmount = Math.max(1, ...gases.map((Gas) => Gas.amount));
    return (
    <Box>
        <Section>
            <LabeledControls>
                <LabeledControls.Item label = "Fuel Temperature">
                    <RoundGauge
                    size={2}
                    value = {fuelTemperature}
                    minValue= {20}
                    maxValue= {900}
                    ranges={{
                        "good": [20, 100],
                        "average": [100, 600],
                        "bad": [600, 900],
                    }}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
                <LabeledControls.Item label = "Fuel Pressure">
                    <RoundGauge
                    size={2}
                    value = {fuelPressure}
                    minValue= {0}
                    maxValue= {10000}
                    alertAfter={5000}
                    format = {formatPressure}
                    ranges={{
                        "good": [0, 500],
                        "average": [500, 5000],
                        "bad": [5000, 10000],
                    }}
                    >
                    </RoundGauge>
                </LabeledControls.Item>
            </LabeledControls>
        </Section>
        <LabeledList>
            {gases.map((Gas) => (
            <LabeledList.Item label={Gas.name}>
                <ProgressBar
                color={Gas.color}
                value={Gas.amount}
                minValue={0}
                maxValue={gasMaxAmount}>
                {formatMass(Gas.mass) + ' '+ toFixed(Gas.amount/fuelTotal * 100, 4) + '%'}
                </ProgressBar>
            </LabeledList.Item>
            ))}
        </LabeledList>



    </Box>);
};
