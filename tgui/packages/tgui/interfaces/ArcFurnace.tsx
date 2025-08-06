import { toFixed } from 'tgui-core/math';
import { useBackend } from "../backend";
import { Button, ProgressBar, Section, RoundGauge, LabeledControls, LabeledList, BlockQuote } from 'tgui-core/components';
import { formatSiUnit } from "tgui-core/format";
import { Window } from "../layouts";

const formatPressure = value => {
  if (value < 10000) {
    return toFixed(value) + ' kPa';
  }
  return formatSiUnit(value * 1000, 1, 'Pa');
};

const formatKg = value => {
  return toFixed(value) + 'kg';
};

const formatLoad = value => {
  return formatSiUnit(value, 1, 'W');
};

const formatTemp = value => {
  return toFixed(value) + 'K';
};

type InputData = {
  has_canister: boolean;
  canister_content_mass: number;
  canister_content_temperature: number;
  canister_content_pressure: number;
  canister_content_fluidlevel: number;
  power_consumption: number;
  conductivity: number;
  is_operating: boolean;
}

export const ArcFurnace = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  return (
    <Window width = {600} height = {350} theme="engineering">
      <Window.Content>
        <Section title = "Loaded Canister">
          <LabeledControls>
            <LabeledControls.Item label="Mass Content">
              <RoundGauge
              size={1.75}
              value={data.canister_content_mass}
              minValue={0}
              maxValue={50000}
              format = {formatKg}>
              </RoundGauge>
            </LabeledControls.Item>
            <LabeledControls.Item label="Temperature">
              <RoundGauge
              size={1.75}
              value={data.canister_content_temperature}
              minValue={293}
              maxValue={3700}
              format = {formatTemp}
              ></RoundGauge>
            </LabeledControls.Item>
            <LabeledControls.Item label="Pressure">
              <RoundGauge
              size={1.75}
              value={data.canister_content_pressure}
              minValue={101}
              maxValue={707}
              format = {formatPressure}
              ></RoundGauge>
            </LabeledControls.Item>
            <LabeledControls.Item label="Fluid Level">
              <RoundGauge
              size={1.75}
              value={data.canister_content_fluidlevel}
              minValue={0}
              maxValue={100}
              ></RoundGauge>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
        <Section title = "Operation">
          <Button color = "green" icon="power-off" disabled={!data.has_canister} onClick={() => act('start')}></Button>
          <Button color = "red" icon="power-off" disabled={!data.has_canister} onClick={() => act('stop')}></Button>
          <BlockQuote>Conductivity is directly related to integrity and coking of the electrodes, as well as how much gas is in the furnace.</BlockQuote>
          <LabeledList>
            <LabeledList.Item label = "Power Draw">
              <ProgressBar
                minValue = {0}
                maxValue = {178000000}
                value = {data.power_consumption}>
                {formatLoad(data.power_consumption)}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label = "Conductivity">
              <ProgressBar
                minValue = {0}
                maxValue = {100}
                value = {data.conductivity}>
                {data.conductivity}%
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
          <BlockQuote>Low Conductivity or overburdening the furnace with ore will cause arcing instability.</BlockQuote>
        </Section>
      </Window.Content>
    </Window>
  )
}
