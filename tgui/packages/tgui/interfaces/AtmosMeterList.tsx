import { toFixed } from 'common/math';
import { useBackend} from "../backend";
import { Box, Table, Tooltip, BlockQuote } from "../components";
import { formatSiUnit } from "../format";
import { Window } from "../layouts";

type Meter = {
  name: string;
  description: string;
  pressure: number;
  temperature: number;
  mass: number
}

type InputData = {
  meterlist: Meter[];
}

const formatPressure = value => {
  if (value < 10000) {
    return toFixed(value) + ' kPa';
  }
  return formatSiUnit(value * 1000, 1, 'Pa');
};

const formatTemperature = value => {
  return toFixed(value) + ' K';
};

export const AtmosMeterList = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);

  return (
    <Window width={400} height={300} theme="ntos">
      <Window.Content>
            <Table>
              <Table.Row header>
                <Table.Cell textAlign="center">Meter ID</Table.Cell>
                <Table.Cell collapsing textAlign="center">Pressure</Table.Cell>
                <Table.Cell collapsing textAlign="center">Temperature</Table.Cell>
                <Table.Cell collapsing textAlign="center">Mass</Table.Cell>
              </Table.Row>
              {data.meterlist.map(meter => (
                <Table.Row key={meter}>
                  <Table.Cell><Tooltip content={meter.description}><Box position="relative">{meter.name}</Box></Tooltip></Table.Cell>
                  <Table.Cell>{formatPressure(meter.pressure)}</Table.Cell>
                  <Table.Cell>{formatTemperature(meter.temperature)}</Table.Cell>
                  <Table.Cell>{Math.round(meter.mass)}kg</Table.Cell>
                </Table.Row>
              ))}
            </Table>
            <BlockQuote>Pipes are generally rated for no more than 11MPa of pressure, with exceptions.</BlockQuote>
      </Window.Content>
    </Window>
  )
}
