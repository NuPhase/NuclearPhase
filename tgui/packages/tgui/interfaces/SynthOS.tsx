import { useBackend, useSharedState } from '../backend';
import { Flex, Section, Tabs, Box, BlockQuote, Dimmer, LabeledList, ProgressBar } from '../components';
import { Window } from "../layouts";

export const SynthOS = (props: any, context: any) => {
  return (
    <Window
      width={800}
      height={600}
      theme="robotics">
      <Window.Content>
        <SynthOSContent />
      </Window.Content>
    </Window>
  );
};

type Organ = {
  name: string;
  damage_percentage: number;
  is_critical: boolean;
  dead: boolean;
}

type InputData = {
  externalorganlist: Organ[];
  internalorganlist: Organ[];
  body_temperature: number;
  water_consumption: number;
  water_level: number;
  nutrient_level: number;
}

export const SynthOSContent = (props, context) => {
  const { data } = useBackend<InputData>(context);
  const [tab_main, setTab_main] = useSharedState(context, 'tab_main', 1);
  const [tab_sub, setTab_sub] = useSharedState(context, 'tab_sub', 1);
  const cooling_pressure:number = Math.round(117 + Math.random() * 5);
  return (
    <Flex
      direction={"column"}>
      <Flex.Item
        position="relative"
        mb={1}>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 1}
            onClick={() => setTab_main(1)}>
            Status
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 2}
            onClick={() => setTab_main(2)}>
            Configuration
          </Tabs.Tab>
        </Tabs>
      </Flex.Item>
      {tab_main === 1 && (
        <>
          <Flex
            direction={"row"}>
            <Flex.Item
              width="60%">
              <Section
                textAlign = "center"
                title="Operating Condition"
                fill>
                <Section textAlign="left">
                  <LabeledList>
                    <LabeledList.Item label = "Cooling Loop Pressure">
                      <ProgressBar
                        minValue = {50}
                        maxValue = {150}
                        ranges={{
                          green: [50, 150],
                        }}
                        textColor = "white"
                        value = {cooling_pressure}>
                        {cooling_pressure}kPa
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Item label = "Cooling Loop Temperature">
                      <ProgressBar
                        minValue = {17}
                        maxValue = {430}
                        ranges={{
                          bad: [350, 430],
                          good: [300, 310],
                          average: [310, 350],
                          teal: [17, 300],
                        }}
                        textColor = "white"
                        value = {data.body_temperature}>
                        {data.body_temperature}K
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Item label = "Water Level">
                      <ProgressBar
                        minValue = {0}
                        maxValue = {100}
                        ranges={{
                          bad: [5, 25],
                          good: [50, 75],
                          average: [25, 50],
                          teal: [75, 100],
                        }}
                        textColor = "white"
                        value = {data.water_level}>
                        {data.water_level}% ({data.water_consumption}ml/min)
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Item label = "Glucose Supplies">
                      <ProgressBar
                        minValue = {0}
                        maxValue = {100}
                        ranges={{
                          bad: [5, 25],
                          good: [50, 75],
                          average: [25, 50],
                          teal: [75, 100],
                        }}
                        textColor = "white"
                        value = {data.nutrient_level}>
                        {data.nutrient_level}%
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Item label = "Current Directive">
                      <Box bold = {1}>NONE</Box>
                    </LabeledList.Item>
                    <LabeledList.Item label = "Assigned Authority">
                      <Box>NONE</Box>
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </Section>
            </Flex.Item>
            <Flex.Item
              width="40%"
              ml={1}>
              <Section
                textAlign = "center"
                title="Structural Analysis"
                fitted>
                <BlockQuote>Percentages reflect the projected integrity related to a TFC(Total failure condition).</BlockQuote>
                <Tabs
                  fluid={1}
                  textAlign="center">
                  <Tabs.Tab
                    icon=""
                    lineHeight="23px"
                    selected={tab_sub === 1}
                    onClick={() => setTab_sub(1)}>
                    External
                  </Tabs.Tab>
                  <Tabs.Tab
                    icon=""
                    lineHeight="23px"
                    selected={tab_sub === 2}
                    onClick={() => setTab_sub(2)}>
                    Internal
                  </Tabs.Tab>
                </Tabs>
              </Section>
              {tab_sub === 1 && (
                <Section>
                  {data.externalorganlist.map(Organ => (
                    <Box
                      mb = {2}
                      bold = {Organ.is_critical}>
                      {Organ.name} - {Organ.dead ? "Unresponsive": "Operational"} [{Organ.damage_percentage}%]
                    </Box>
                  ))}
                </Section>
              )}
              {tab_sub === 2 && (
                <Section>
                  {data.internalorganlist.map(Organ => (
                    <Box
                      mb = {2}
                      bold = {Organ.is_critical}>
                      {Organ.name} - {Organ.dead ? "Unresponsive": "Operational"} [{Organ.damage_percentage}%]
                    </Box>
                  ))}
                </Section>
              )}
            </Flex.Item>
          </Flex>
        </>
      )}
      {tab_main === 2 && (
        <Flex.Item
          height={40}>
          CONTENT
        </Flex.Item>
      )}
    </Flex>
  );
};

