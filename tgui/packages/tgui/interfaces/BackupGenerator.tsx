import { toFixed } from 'tgui-core/math';
import { useBackend} from "../backend";
import { Button, Section, RoundGauge, LabeledControls } from 'tgui-core/components';
import { formatSiUnit } from "tgui-core/format";
import { Window } from "../layouts";

const formatPressure = value => {
  if (value < 10000) {
    return toFixed(value) + ' kPa';
  }
  return formatSiUnit(value * 1000, 1, 'Pa');
};

const formatPercent = value => {
  return toFixed(value, 1) + '%';
};

const formatTemperature = value => {
  return toFixed(value, 1) + 'C';
};

const formatFuelFlow = value => {
  return toFixed(value) + 'kg/h';
};

const formatLoad = value => {
  return formatSiUnit(value, 1, 'W');
};

type InputData = {
  rpm: number;
  load: number;
  temperature: number; // in celsius!
  fuelFlow:number;
  efficiency:number; // percent
}

export const BackupGenerator = (props: any) => {
  const { act, data } = useBackend<InputData>();
  return (
    <Window width = {250} height = {300} theme="engineering">
      <Window.Content>
        <Section title = "General">
          <Button color = "green" onClick={() => act('stop')}>
          STOP</Button >
          <Button color = "red" onClick={() => act('start')}>
          START</Button>
          <LabeledControls>
            <LabeledControls.Item label="RPM">
              <RoundGauge
              size={1.75}
              value={data.rpm}
              minValue={0}
              maxValue={2000}
              alertAfter={1801}
              alertBefore={1799}
              ranges={{
                "average": [100, 1750],
                "good": [1750, 1850],
                "bad": [1850, 2000]
              }}>
              </RoundGauge>
            </LabeledControls.Item>
            <LabeledControls.Item label="Load">
              <RoundGauge
              size={1.75}
              value={data.load}
              minValue={0}
              maxValue={10000000}
              ranges={{
                "good": [0, 1000000],
                "average": [1000000, 10000000],
              }}
              format = {formatLoad}
              ></RoundGauge>
            </LabeledControls.Item>
            <LabeledControls.Item label="Temperature">
              <RoundGauge
              size={1.75}
              value={data.temperature}
              minValue={20}
              maxValue={250}
              ranges={{
                "good": [20, 116],
                "average": [116, 216],
                "bad": [216, 250]
              }}
              format={formatTemperature}></RoundGauge>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
        <Section title = "Stats">
        <LabeledControls>
            <LabeledControls.Item label="Fuel Flow">
              <RoundGauge
              size={1.75}
              value={data.fuelFlow}
              minValue={0}
              maxValue={500}
              format={formatFuelFlow}></RoundGauge>
            </LabeledControls.Item>
            <LabeledControls.Item label="Efficiency">
              <RoundGauge
              size={1.75}
              value={data.efficiency}
              minValue={30}
              maxValue={50}
              ranges={{
                "good": [40, 50],
                "average": [30, 40],
              }}
              format={formatPercent}></RoundGauge>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  )
}
