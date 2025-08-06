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

const formatKg = value => {
  return toFixed(value) + 'kg/s';
};

const formatLoad = value => {
  return formatSiUnit(value, 1, 'W');
};

type InputData = {
  flow_capacity: number;
  actual_mass_flow: number;
  mode: string;
  target_rpm: number;
  actual_rpm: number;
  power_draw: number;
  max_power_draw: number;
  inlet_pressure: number;
  exit_pressure: number;
  temperature: number;
}

export const FluidPump = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  return (
    <Window width = {250} height = {300} theme="engineering">
      <Window.Content>
        <Section title = "General">
          <Button selected={data.mode == "OFF" ? 1 : 0 } onClick={() => act('mode_change', {mode_change: "OFF"})}>
          OFF</Button >
          <Button selected={data.mode == "IDLE" ? 1 : 0 } onClick={() => act('mode_change', {mode_change: "IDLE"})}>
          IDLE</Button>
          <Button selected={data.mode == "MAX" ? 1 : 0 } onClick={() => act('mode_change', {mode_change: "MAX"})}>
          MAX</Button>
          <LabeledControls>
            <LabeledControls.Item label="RPM">
              <RoundGauge
              size={1.75}
              value={data.actual_rpm}
              minValue={0}
              maxValue={3100}
              alertAfter={2650}
              alertBefore={900}
              ranges={{
                "good": [data.target_rpm*0.8, data.target_rpm*1.2],
                "average": [100, data.target_rpm*0.8],
                "bad": [2700, 3200],
              }}>
              </RoundGauge>
            </LabeledControls.Item>
            <LabeledControls.Item label="Flow">
              <RoundGauge
              size={1.75}
              value={data.actual_mass_flow}
              minValue={0}
              maxValue={data.flow_capacity}
              ranges={{
                "good": [data.flow_capacity*0.1, data.flow_capacity],
                "average": [0, data.flow_capacity*0.1],
              }}
              format = {formatKg}
              ></RoundGauge>
            </LabeledControls.Item>
            <LabeledControls.Item label="Load">
              <RoundGauge
              size={1.75}
              value={data.power_draw}
              minValue={0}
              maxValue={data.max_power_draw}
              ranges={{
                "good": [0, data.max_power_draw*0.8],
                "average": [data.max_power_draw*0.8, data.max_power_draw],
              }}
              format = {formatLoad}
              ></RoundGauge>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
        <Section title = "Mechanics">
        <LabeledControls>
            <LabeledControls.Item label="Inlet Pressure">
              <RoundGauge
              size={2}
              value={data.inlet_pressure}
              minValue={0}
              maxValue={9000}
              alertAfter={8500}
              ranges={{
                "good": [0, 8500],
                "bad": [8500, 9500],
              }}
              format={formatPressure}></RoundGauge>
            </LabeledControls.Item>
            <LabeledControls.Item label="Exit Pressure">
              <RoundGauge
              size={2}
              value={data.exit_pressure}
              minValue={0}
              maxValue={9000}
              alertAfter={8500}
              ranges={{
                "good": [0, 8500],
                "bad": [8500, 9500],
              }}
              format={formatPressure}></RoundGauge>
            </LabeledControls.Item>
          </LabeledControls>
          Temperature: {Math.round(data.temperature)}K
        </Section>
      </Window.Content>
    </Window>
  )
}
