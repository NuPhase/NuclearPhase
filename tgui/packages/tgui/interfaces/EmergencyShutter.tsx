import { toFixed } from 'common/math';
import { useBackend, useLocalState } from "../backend";
import { Box, Button, LabeledList, NoticeBox, Section, Tabs } from "../components";
import { formatSiUnit } from '../format';
import { Window } from "../layouts";

const formatPressure = value => {
  if (value < 10000) {
    return toFixed(value) + ' kPa';
  }
  return formatSiUnit(value * 1000, 1, 'Pa');
};

type InputData = {
  highest_pressure: number;
  direction: string;
  temperature: number;
  opened: boolean;
  danger: boolean;
}

export const EmergencyShutter = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  return (
    <Window width = {300} height = {285}>
      <Window.Content>
        <Section
          title = "Alarm Details">
          <LabeledList>
            <LabeledList.Item label = "Alert Direction">
              {data.direction}
            </LabeledList.Item>
            <LabeledList.Item label = "Highest Pressure">
              {formatPressure(data.highest_pressure)}
            </LabeledList.Item>
            <LabeledList.Item label = "Highest Temperature">
              {data.temperature}C
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title = "Shutter Control">
          {!data.danger ? null : <NoticeBox danger textAlign = "center">Opening this airlock may result in injury!</NoticeBox>}
          <Button.Confirm
            confirmContent = ""
            confirmColor = "red"
            mx = {10}
            textAlign = "center"
            disabled = {data.opened}
            fontSize = {3}
            tooltip = "Opening this airlock can put you in danger. Think carefully."
            verticalAlignContent = "middle"
            color = {data.danger ? "orange" : "good"}
            onClick={() => act('Open')}>
            OPEN
          </Button.Confirm>
        </Section>
      </Window.Content>
    </Window>
  )
}
