import { useBackend } from '../backend';
import { Knob } from '../components';
import { Window } from '../layouts';

type InputData = {
  minmagnif: number,
  maxmagnif: number,
  magstep: number,
}

export const Zooming = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  return (
    <Window resizable>
      <Window.Content>
        <Knob
          size = {1.5}
          minValue = {data.minmagnif}
          maxValue = {data.maxmagnif}
          step = {data.magstep}
          unit = {"x"}
          onChange = {(e, value) => act('zoom', {entry: value})}>
        </Knob>
      </Window.Content>
    </Window>
  );
};
