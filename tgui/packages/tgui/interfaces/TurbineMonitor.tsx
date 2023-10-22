import { useBackend, useLocalState } from "../backend";
import { LabeledList, ProgressBar, NoticeBox, Section, Tabs } from "../components";
import { Window } from "../layouts";

type InputData = {
  turb1: TurbineData;
  turb2: TurbineData;
}

type TurbineData = {
  rpm: number;
  efficiency: number;
  vibration: string;
  mass_flow: number;
  steam_velocity: number;
  breaks_engaged: boolean;
}

export const TurbineMonitor = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  return (
    <Window width={450} height={450}>
      <Window.Content fitted>
        <Section title="Turbine 1">
          <LabeledList>
            <LabeledList.Item label="RPM">
              <ProgressBar
                ranges={{
                bad: [3700, Infinity],
                good: [3500, 3700],
                average: [800, 3500],
                teal: [0, 800],
                }}
                minValue = {0}
                maxValue = {4000}
                value={data.turb1.rpm}>
                {data.turb1.rpm}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label = "Efficiency">
              <ProgressBar
                  ranges={{
                  good: [0.85, Infinity],
                  average: [0.4, 0.85],
                  bad: [0, 0.4],
                  }}
                  value={data.turb1.efficiency}>
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Vibration">
              {data.turb1.vibration}
            </LabeledList.Item>
            <LabeledList.Item label="Mass Flow">
              {data.turb1.mass_flow}kg/s
            </LabeledList.Item>
            <LabeledList.Item label="Steam Velocity">
              {data.turb1.steam_velocity}m/s
            </LabeledList.Item>
            {!data.turb1.breaks_engaged ? null : <NoticeBox warning>EMERGENCY BRAKES ENGAGED</NoticeBox>}
          </LabeledList>
        </Section>
        <Section title="Turbine 2">
          <LabeledList>
            <LabeledList.Item label="RPM">
              <ProgressBar
                ranges={{
                bad: [3700, Infinity],
                good: [3500, 3700],
                average: [800, 3500],
                teal: [0, 800],
                }}
                value={data.turb2.rpm}>
                {data.turb2.rpm}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label = "Efficiency">
              <ProgressBar
                  ranges={{
                  good: [0.85, Infinity],
                  average: [0.4, 0.85],
                  bad: [0, 0.4],
                  }}
                  minValue = {0}
                  maxValue = {1}
                  value={data.turb2.efficiency}>
                </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Vibration">
              {data.turb2.vibration}
            </LabeledList.Item>
            <LabeledList.Item label="Mass Flow">
              {data.turb2.mass_flow}kg/s
            </LabeledList.Item>
            <LabeledList.Item label="Steam Velocity">
              {data.turb2.steam_velocity}m/s
            </LabeledList.Item>
            {!data.turb2.breaks_engaged ? null : <NoticeBox warning>EMERGENCY BRAKES ENGAGED</NoticeBox>}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
