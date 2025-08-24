import { toFixed } from 'tgui-core/math';
import { useBackend } from '../backend';
import { Box, Button, Flex, Icon, Knob, LabeledControls, LabeledList, RoundGauge, Section, Tooltip } from 'tgui-core/components';
import { formatSiUnit } from 'tgui-core/format';
import { Window } from '../layouts';

const formatPressure = value => {
  if (value < 10000) {
    return toFixed(value) + ' kPa';
  }
  return formatSiUnit(value * 1000, 1, 'Pa');
};

const formatTemperature = value => {
  return toFixed(value) + ' K';
};

type InputData = {
  portConnected: boolean;
  tankPressure: number;
  tankLevel: number;
  tankTemperature: number;
  closestBoilingPoint: number;
  closestMeltingPoint: number;
  maxBoilingPoint: number;
  minMeltingPoint: number;
  releasePressure: number;
  defaultReleasePressure: number;
  minReleasePressure: number;
  maxReleasePressure: number;
  pressureLimit: number;
  valveOpen: boolean;
  isPrototype: boolean;
  hasHoldingTank: boolean;
  holdingTank: holdingTank;
  holdingTankLeakPressure: number;
  holdingTankFragPressure: number;
  restricted: boolean;
}

type holdingTank = {
  name: string;
  tankPressure: number;
}

export const Canister = (props) => {
  const { act, data } = useBackend<InputData>();
  return (
    <Window
      width={375}
      height={275}>
      <Window.Content>
        <Flex direction="column" height="100%">
          <Flex.Item mb={1}>
            <Section
              title="Canister"
              buttons={(
                <>
                  {!!data.isPrototype && (
                    <Button
                      mr={1}
                      icon={data.restricted ? 'lock' : 'unlock'}
                      color="caution"
                      content={data.restricted
                        ? 'Engineering'
                        : 'Public'}
                      onClick={() => act('restricted')} />
                  )}
                  <Button
                    icon="pencil-alt"
                    content="Relabel"
                    onClick={() => act('relabel')} />
                </>
              )}>
              <LabeledControls>
                <LabeledControls.Item
                  minWidth="66px"
                  label="Pressure">
                  <RoundGauge
                    size={2}
                    value={data.tankPressure}
                    minValue={0}
                    maxValue={data.pressureLimit}
                    alertAfter={data.pressureLimit * 0.70}
                    ranges={{
                      "good": [0, data.pressureLimit * 0.70],
                      "average": [data.pressureLimit * 0.70, data.pressureLimit * 0.85],
                      "bad": [data.pressureLimit * 0.85, data.pressureLimit],
                    }}
                    format={formatPressure} />
                </LabeledControls.Item>
                <LabeledControls.Item
                  minWidth="66px"
                  label="Fluid Level">
                  <RoundGauge
                    size={2}
                    value={data.tankLevel}
                    minValue={0}
                    maxValue={100}
                    ranges={{
                      "good": [50, 100],
                      "average": [20, 50],
                      "bad": [0, 20],
                    }}
                    />
                </LabeledControls.Item>
                <LabeledControls.Item
                  label=""
                  minWidth="66px">
                  <RoundGauge
                    size={2}
                    value={data.tankTemperature}
                    minValue={data.minMeltingPoint}
                    maxValue={data.maxBoilingPoint}
                    ranges={{
                      "red": [data.closestBoilingPoint-5, data.closestBoilingPoint+5],
                      "yellow": [data.closestMeltingPoint-5, data.closestMeltingPoint+5],
                      "blue": [data.minMeltingPoint, data.minMeltingPoint+5],
                    }}
                    format={formatTemperature} />
                </LabeledControls.Item>
                <LabeledControls.Item label="Regulator">
                  <Box
                    position="relative"
                    left="-8px">
                    <Knob
                      size={1.25}
                      color={!!data.valveOpen && 'yellow'}
                      value={data.releasePressure}
                      unit="kPa"
                      minValue={data.minReleasePressure}
                      maxValue={data.maxReleasePressure}
                      step={5}
                      stepPixelSize={1}
                      onDrag={(e, value) => act('pressure', {
                        pressure: value,
                      })} />
                    <Button
                      fluid
                      position="absolute"
                      top="-2px"
                      right="-20px"
                      color="transparent"
                      icon="fast-forward"
                      onClick={() => act('pressure', {
                        pressure: data.maxReleasePressure,
                      })} />
                    <Button
                      fluid
                      position="absolute"
                      top="16px"
                      right="-20px"
                      color="transparent"
                      icon="undo"
                      onClick={() => act('pressure', {
                        pressure: data.defaultReleasePressure,
                      })} />
                  </Box>
                </LabeledControls.Item>
                <LabeledControls.Item label="Valve">
                  <Button
                    my={0.5}
                    width="50px"
                    lineHeight={2}
                    fontSize="11px"
                    color={data.valveOpen
                      ? (data.hasHoldingTank ? 'caution' : 'danger')
                      : null}
                    content={data.valveOpen ? 'Open' : 'Closed'}
                    onClick={() => act('valve')} />
                </LabeledControls.Item>
                <LabeledControls.Item
                  mr={1}
                  label="Port">
                  <Tooltip
                    content={data.portConnected
                      ? 'Connected'
                      : 'Disconnected'}
                    position="top"
                  >
                    <Box position="relative">
                      <Icon
                        size={1.25}
                        name={data.portConnected ? 'plug' : 'times'}
                        color={data.portConnected ? 'good' : 'bad'} />
                    </Box>
                  </Tooltip>
                </LabeledControls.Item>
              </LabeledControls>
            </Section>
          </Flex.Item>
          <Flex.Item grow={1}>
            <Section
              height="100%"
              title="Holding Tank"
              buttons={!!data.hasHoldingTank && (
                <Button
                  icon="eject"
                  color={data.valveOpen && 'danger'}
                  content="Eject"
                  onClick={() => act('eject')} />
              )}>
              {!!data.hasHoldingTank && (
                <LabeledList>
                  <LabeledList.Item label="Label">
                    {data.holdingTank.name}
                  </LabeledList.Item>
                  <LabeledList.Item label="Pressure">
                    <RoundGauge
                      value={data.holdingTank.tankPressure}
                      minValue={0}
                      maxValue={data.holdingTankFragPressure * 1.15}
                      alertAfter={data.holdingTankLeakPressure}
                      ranges={{
                        "good": [0, data.holdingTankLeakPressure],
                        "average": [data.holdingTankLeakPressure, data.holdingTankFragPressure],
                        "bad": [data.holdingTankFragPressure, data.holdingTankFragPressure * 1.15],
                      }}
                      format={formatPressure}
                      size={1.75} />
                  </LabeledList.Item>
                </LabeledList>
              )}
              {!data.hasHoldingTank && (
                <Box color="average">
                  No Holding Tank
                </Box>
              )}
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
