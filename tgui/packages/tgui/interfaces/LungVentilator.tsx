import { useBackend, useLocalState } from "../backend";
import { LabeledList, ProgressBar, Tabs, Slider, Button, Section, Knob} from "../components";
import { Window } from "../layouts";

type InputData = {
  pressure_o2: number;
  pressure_n2: number;
  pressure_n2o: number;
  pressure_total: number;
  isPumping: boolean; //does it actively force air into the victim
  isWorking: boolean; //does it even provide air at all
  pump_rate: number;
}

export const LungVentilator = (props: any, context: any) => {
  const { act, data } = useBackend<InputData>(context);
  return (
    <Window width={300} height={300}>
      <Window Content>
        <LabeledList>
          <LabeledList.Item label="O2">
            <Slider
              animated
              color = "teal"
              value = {data.pressure_o2}
              stepPixelSize = {5}
              unit = "kPa"
              onChange = {(_, value) => act('change_o2', { entry: value })}
              minValue = {0}
              maxValue = {101}>
            </Slider>
          </LabeledList.Item>
          <LabeledList.Item label="N2">
            <Slider
              animated
              color = "red"
              value = {data.pressure_n2}
              stepPixelSize = {5}
              unit = "kPa"
              onChange = {(_, value) => act('change_n2', { entry: value })}
              minValue = {0}
              maxValue = {303}>
            </Slider>
          </LabeledList.Item>
          <LabeledList.Item label="N2O">
            <Slider
              animated
              color = "pink"
              value = {data.pressure_n2o}
              stepPixelSize = {5}
              unit = "kPa"
              onChange = {(_, value) => act('change_n2o', { entry: value })}
              minValue = {0}
              maxValue = {33}>
            </Slider>
          </LabeledList.Item>
          <LabeledList.Item label="Pressure">
            <ProgressBar
              value = {data.pressure_total}
              minValue = {0}
              maxValue = {437}
              ranges={{
                good: [80, 437],
                average: [33, 80],
                bad: [0, 33],
                }}
            >{data.pressure_total} kPa</ProgressBar>
          </LabeledList.Item>
        </LabeledList>
        <Section title = "Configuration">
          <Button
            width = {6}
            height = {3}
            selected = {data.isWorking}
            onClick={() => act("toggle")}
            >ON/OFF</Button>
          <Button
            width = {6}
            height = {3}
            disabled = {!data.isWorking}
            selected = {data.isPumping}
            tooltip = "This device can force the patient to breathe by directly pumping gas into their lungs. Very unpleasant."
            onClick={() => act("ventilation")}
            >Ventilation</Button>
          <Knob
            size = {1.5}
            color = "blue"
            value = {data.pump_rate}
            stepPixelSize = {5}
            minValue = {1}
            maxValue = {32}
            unit = "Breaths/Min"
            onChange = {(_, value) => act('change_pump_rate', { entry: value })}>
          </Knob>
        </Section>
      </Window>
    </Window>
  )
}
