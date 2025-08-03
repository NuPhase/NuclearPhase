import { toFixed } from 'tgui-core/math';
import { useBackend, useLocalState } from "../backend";
import { Button, Box, Section, RoundGauge, LabeledControls } from 'tgui-core/components';
import { formatSiUnit } from "tgui-core/format";
import { Window } from "../layouts";

const formatKg = value => {
  return toFixed(value) + 'kg';
};

const formatTemp = value => {
  return toFixed(value) + 'K';
};

type InputData = {
  has_canister: boolean;
  canister_content_mass: number;
  canister_content_temperature: number;
  is_operating: boolean;
}

export const MetalCaster = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  const [cast_type, setCastType] = useLocalState(context, "cast_type", null);
  return (
    <Window width = {250} height = {300} theme="engineering">
      <Window.Content>
        <Section title = "Loaded Canister">
          <Button disabled={!data.has_canister || data.is_operating} onClick={() => act('remove_canister')}>Eject Canister</Button >
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
          </LabeledControls>
        </Section>
        <Section title = "Operation">
          <Button color = "green" icon="power-off" disabled={!data.has_canister} onClick={() => act('start', {"cast_type" : cast_type})}></Button>
          <Button color = "red" icon="power-off" disabled={!data.has_canister} onClick={() => act('stop')}></Button>
          <Button
            selected = {cast_type == "ingot"}
            disabled = {data.is_operating}
            onClick = {() => setCastType("ingot")}>
          Ingots</Button>
          <Button
            selected = {cast_type == "rod"}
            disabled = {data.is_operating}
            onClick = {() => setCastType("rod")}>
          Rods</Button>
          <Button
            selected = {cast_type == "sheet"}
            disabled = {data.is_operating}
            onClick = {() => setCastType("sheet")}>
          Sheets</Button>
        </Section>
      </Window.Content>
    </Window>
  )
}
