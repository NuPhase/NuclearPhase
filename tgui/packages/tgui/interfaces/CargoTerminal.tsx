import { useBackend, useSharedState } from "../backend";
import { Box, Tabs, Icon, Tooltip, Table, Button, Section, NumberInput, Stack } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import { Window } from "../layouts";

const formatFluidVolume = value => {
    if (value < 1000) {
    return Math.round(value) + 'ml';
    }
    if (value < 1000000) {
    return toFixed(value/1000, 2) + 'L';
    }
    if (value < 1000000000) {
    return toFixed(value/1000000, 2) + 'm3';
    }
};

const formatFluidMass = value => {
    if (value < 1) {
    return toFixed(value*1000) + 'mg';
    }
    if (value < 1000) {
    return toFixed(value, 2) + 'kg';
    }
    return toFixed(value/1000, 2) + 't';
};

const formatItemMass = value => {
    if (value < 1) {
    return toFixed(value*1000) + 'g';
    }
    if (value < 1000) {
    return toFixed(value, 2) + 'kg';
    }
    return toFixed(value/1000, 2) + 't';
};

type Item = {
  name: string;
  amount: number;
  weight: number;
  type: string;
}

type ItemCart = {
  name: string;
  amount: number;
  type: string;
  maxAmount: number;
}

type Fluid = {
  name: string;
  color: string;
  amount: number;
  molarVolume: number;
  molarMass: number;
  toxicity: number;
  radioactivity: number;
  loreText: string;
  type: string;
}

type FluidCart = {
  name: string;
  amount: number;
  type: string;
  container: string;
  maxAmount: number;
}

type InputData = {
  items: Item[];
  fluids: Fluid[];
  itemCart: ItemCart[];
  fluidCart: FluidCart[];
}

export const CargoTerminal = (props: any) => {
  const { act, data } = useBackend<InputData>();
  const [selectedTab, setSelectedTab] = useSharedState("tab", "Cart");
  return (
    <Window width = {800} height = {600}>
      <Window.Content>
        <Stack>
          <Stack.Item width="20%">
            <Section>
              <Button
                selected = {selectedTab == "Cart"}
                onClick = {() => setSelectedTab("Cart")}>
              Cart</Button>
              <Button
                selected = {selectedTab == "Items"}
                onClick = {() => setSelectedTab("Items")}>
              Items</Button>
              <Button
                selected = {selectedTab == "Materials"}
                onClick = {() => setSelectedTab("Materials")}>
              Materials</Button>
            </Section>
            <Section>
              <Button
                onClick={() => act('raise')}
              >Raise</Button>
              <Button
                onClick={() => act('lower')}
              >Lower</Button>
            </Section>
          </Stack.Item>
          <Stack.Item height={45} width="80%">
            {selectedTab === "Cart" && <CartTab></CartTab>}
            {selectedTab === "Items" && <ItemTab></ItemTab>}
            {selectedTab === "Materials" && <MaterialTab></MaterialTab>}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  )
}

const CartTab = (props) => {
    const { act, data } = useBackend<InputData>();
    return (
        <Box>
          <Section title = "Items">
            <Table>
                <Table.Row header>
                  <Table.Cell></Table.Cell>
                  <Table.Cell>Name</Table.Cell>
                  <Table.Cell collapsing>
                    Amount
                  </Table.Cell>
                </Table.Row>
                {data.itemCart.map(ItemCart => (
                  <Table.Row key={ItemCart.name}>
                    <Table.Cell collapsing>
                      <Button
                        color = "cyan"
                        tooltip = "Remove item from cart."
                        onClick={() => act('uncartItem', { itemType: ItemCart.type })}
                        >Remove
                      </Button>
                    </Table.Cell>
                    <Table.Cell><Box position="relative">{ItemCart.name}</Box></Table.Cell>
                    <Table.Cell collapsing textAlign="center">
                      <NumberInput
                        value={ItemCart.amount}
                        minValue={1}
                        maxValue={ItemCart.maxAmount}
                        step={1}
                        animated
                        onChange={(value) => act('setCartItemAmount', { itemType: ItemCart.type, newAmount: value })}
                      ></NumberInput>
                    </Table.Cell>
                  </Table.Row>
                ))}
            </Table>
          </Section>
          <Section title = "Materials">
            <Table>
                <Table.Row header>
                  <Table.Cell></Table.Cell>
                  <Table.Cell>Name</Table.Cell>
                  <Table.Cell collapsing>
                    Amount
                  </Table.Cell>
                  <Table.Cell>Container</Table.Cell>
                </Table.Row>
                {data.fluidCart.map(FluidCart => (
                  <Table.Row key={FluidCart.name}>
                    <Table.Cell collapsing>
                      <Button
                        color = "cyan"
                        tooltip = "Remove fluid from cart."
                        onClick={() => act('uncartFluid', { fluidType: FluidCart.type })}
                        >Remove
                      </Button>
                    </Table.Cell>
                    <Table.Cell><Box position="relative">{FluidCart.name}</Box></Table.Cell>
                    <Table.Cell collapsing textAlign="center">
                      <NumberInput
                        value={FluidCart.amount}
                        minValue={1}
                        maxValue={FluidCart.maxAmount}
                        step={1}
                        animated
                        onChange={(value) => act('setCartFluidAmount', { fluidType: FluidCart.type, newAmount: value })}
                      ></NumberInput>
                    </Table.Cell>
                    <Table.Cell collapsing textAlign="center">
                      <Button
                        selected = {FluidCart.container == "canister"}
                        onClick={() => act('setCartFluidContainer', { fluidType: FluidCart.type, newContainer: "canister" })}
                      >Canister</Button>
                      <Button
                        selected = {FluidCart.container == "barrel"}
                        onClick={() => act('setCartFluidContainer', { fluidType: FluidCart.type, newContainer: "barrel" })}
                      >Barrel</Button>
                      <Button
                        selected = {FluidCart.container == "bottle"}
                        onClick={() => act('setCartFluidContainer', { fluidType: FluidCart.type, newContainer: "bottle" })}
                      >Bottle</Button>
                      <Button
                        selected = {FluidCart.container == "ingots"}
                        onClick={() => act('setCartFluidContainer', { fluidType: FluidCart.type, newContainer: "ingots" })}
                      >Ingots</Button>
                    </Table.Cell>
                  </Table.Row>
                ))}
            </Table>
          </Section>
        </Box>
    );
};

const ItemTab = (props) => {
    const { act, data } = useBackend<InputData>();
    return (
        <Section scrollable fill>
          <Table>
              <Table.Row header>
                <Table.Cell></Table.Cell>
                <Table.Cell>Name</Table.Cell>
                <Table.Cell collapsing>Weight</Table.Cell>
                <Table.Cell collapsing textAlign="center">
                  Amount
                </Table.Cell>
              </Table.Row>
              {data.items.map(Item => (
                <Table.Row key={Item.name}>
                  <Table.Cell collapsing>
                    <Button
                      color = "cyan"
                      tooltip = "Move the item to cart."
                      onClick={() => act('cartItem', { itemType: Item.type })}
                      >To Cart
                    </Button>
                  </Table.Cell>
                  <Table.Cell><Box position="relative">{Item.name}</Box></Table.Cell>
                  <Table.Cell>{formatItemMass(Item.weight)}</Table.Cell>
                  <Table.Cell collapsing textAlign="center">
                    {Item.amount}
                  </Table.Cell>
                </Table.Row>
              ))}
          </Table>
        </Section>
    );
};

const MaterialTab = (props) => {
    const { act, data } = useBackend<InputData>();
    return (
        <Section scrollable fill>
          <Table>
              <Table.Row header>
                <Table.Cell></Table.Cell>
                <Table.Cell width={1}></Table.Cell>
                <Table.Cell>Name</Table.Cell>
                <Table.Cell collapsing>Volume</Table.Cell>
                <Table.Cell collapsing>Weight</Table.Cell>
                <Table.Cell collapsing textAlign="center">
                  Hazards
                </Table.Cell>
              </Table.Row>
              {data.fluids.map(Fluid => (
                <Table.Row key={Fluid.name}>
                  <Table.Cell collapsing>
                    <Button
                      color = "cyan"
                      tooltip = "Move the fluid to cart."
                      onClick={() => act('cartFluid', { fluidType: Fluid.type })}
                      >To Cart
                    </Button>
                  </Table.Cell>
                  <Table.Cell collapsing width={1}><Icon name = "circle" color={Fluid.color}></Icon></Table.Cell>
                  <Table.Cell><Tooltip content={Fluid.loreText}><Box position="relative">{Fluid.name}</Box></Tooltip></Table.Cell>
                  <Table.Cell collapsing>
                    {formatFluidVolume(Fluid.amount)}
                  </Table.Cell>
                  <Table.Cell collapsing>
                    {formatFluidMass((Fluid.amount/Fluid.molarVolume)*Fluid.molarMass)}
                  </Table.Cell>
                  <Table.Cell>Hazards</Table.Cell>
                </Table.Row>
              ))}
          </Table>
        </Section>
    );
};