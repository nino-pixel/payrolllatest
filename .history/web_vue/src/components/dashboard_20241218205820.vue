<template>
  <DashboardLayout>
    <div class="space-y-4">
      <div class="flex justify-between items-center">
        <div>
          <h2 class="text-3xl font-bold">$6468.96</h2>
          <p class="text-muted-foreground">Current Month Earnings</p>
        </div>
        <div class="flex space-x-2">
          <Button variant="outline">Daily</Button>
          <Button variant="outline">Weekly</Button>
          <Button variant="outline">Monthly</Button>
          <Button variant="outline">Yearly</Button>
        </div>
      </div>

      <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card
          v-for="(card, index) in cards"
          :key="index"
          :class="`bg-${card.color}-500 text-white`"
        >
          <CardHeader class="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle class="text-sm font-medium">{{ card.title }}</CardTitle>
          </CardHeader>
          <CardContent>
            <div class="text-2xl font-bold">$432</div>
            <div class="h-[80px]">
              <ResponsiveContainer width="100%" height="100%">
                <component :is="card.chartType" :data="data" />
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>
      </div>

      <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
        <Card class="col-span-4">
          <CardHeader>
            <CardTitle>Overview</CardTitle>
          </CardHeader>
          <CardContent class="pl-2">
            <div class="h-[300px]">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart :data="data">
                  <Line
                    type="monotone"
                    dataKey="value"
                    stroke="hsl(var(--primary))"
                    :strokeWidth="2"
                  />
                  <Tooltip />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>
        <Card class="col-span-3">
          <CardHeader>
            <CardTitle>Distribution</CardTitle>
          </CardHeader>
          <CardContent>
            <div class="h-[300px]">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    :data="revenueData"
                    cx="50%"
                    cy="50%"
                    :labelLine="false"
                    :outerRadius="80"
                    fill="#8884d8"
                    dataKey="value"
                  >
                    <Cell
                      v-for="(entry, index) in revenueData"
                      :key="`cell-${index}`"
                      :fill="COLORS[index % COLORS.length]"
                    />
                  </Pie>
                  <Tooltip />
                </PieChart>
              </ResponsiveContainer>
            </div>
            <div class="mt-4 flex justify-between">
              <div
                v-for="entry in revenueData"
                :key="entry.name"
                class="text-center"
              >
                <div class="text-2xl font-bold">{{ entry.value }}%</div>
                <div class="text-sm text-muted-foreground">{{ entry.name }}</div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <div class="grid gap-4 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Recent Activities</CardTitle>
          </CardHeader>
          <CardContent>
            <div class="space-y-4">
              <div
                v-for="(activity, index) in activities"
                :key="index"
                class="flex items-center"
              >
                <div
                  class="w-9 h-9 rounded-full mr-3 flex items-center justify-center"
                  :class="`bg-${activity.color}-500`"
                >
                  <span class="text-white text-xl">●</span>
                </div>
                <div>
                  <h3 class="font-semibold">{{ activity.title }}</h3>
                  <p class="text-sm text-muted-foreground">{{ activity.description }}</p>
                  <p class="text-xs text-muted-foreground">{{ activity.time }}</p>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader>
            <CardTitle>Order Status</CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>INVOICE</TableHead>
                  <TableHead>CUSTOMER</TableHead>
                  <TableHead>PRICE</TableHead>
                  <TableHead>STATUS</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow v-for="(order, index) in orders" :key="index">
                  <TableCell>{{ order.invoice }}</TableCell>
                  <TableCell>{{ order.customer }}</TableCell>
                  <TableCell>{{ order.price }}</TableCell>
                  <TableCell>
                    <span
                      class="px-2 py-1 rounded-full text-xs"
                      :class="statusClass(order.status)"
                    >
                      {{ order.status }}
                    </span>
                  </TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </div>
    </div>
  </DashboardLayout>
</template>

<script>
import {
  BarChart,
  LineChart,
  PieChart,
  Line,
  Bar,
  Pie,
  Cell,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

export default {
  components: {
    BarChart,
    LineChart,
    PieChart,
    Line,
    Bar,
    Pie,
    Cell,
    Tooltip,
    ResponsiveContainer,
  },
  data() {
    return {
      data: [
        { month: "Jan", value: 10 },
        { month: "Feb", value: 20 },
        { month: "Mar", value: 15 },
        { month: "Apr", value: 25 },
        { month: "May", value: 18 },
        { month: "Jun", value: 30 },
      ],
      revenueData: [
        { name: "Facebook", value: 33 },
        { name: "Youtube", value: 55 },
        { name: "Direct Search", value: 12 },
      ],
      COLORS: ["#0088FE", "#00C49F", "#FFBB28", "#FF8042"],
      cards: [
        { title: "Revenue Status", color: "pink", chartType: "LineChart" },
        { title: "Page Views", color: "purple", chartType: "LineChart" },
        { title: "Bounce Rate", color: "blue", chartType: "BarChart" },
        { title: "Revenue Status", color: "orange", chartType: "BarChart" },
      ],
      activities: [
        { title: "Task Updated", description: "Nolan Updated a Task", time: "40 min ago", color: "blue" },
        { title: "Deal Added", description: "Pushy Updated a Task", time: "1 day ago", color: "purple" },
        { title: "Published Article", description: "Sophia Updated an Article", time: "40 min ago", color: "green" },
        { title: "Deck Updated", description: "Manish Updated a Deck", time: "1 day ago", color: "yellow" },
      ],
      orders: [
        { invoice: "12308", customer: "Charly Jhons", price: "$526", status: "Process" },
        { invoice: "12309", customer: "Darren Sam", price: "$300", status: "Open" },
        { invoice: "12310", customer: "Sophie Lee", price: "$750", status: "Delivered" },
        { invoice: "12311", customer: "John Doe", price: "$450", status: "Pending" },
        { invoice: "12312", customer: "Emily Blunt", price: "$600", status: "Closed" },
      ],
    };
  },
  methods: {
    statusClass(status) {
      const statusColors = {
        Process: "bg-pink-200 text-pink-800",
        Open: "bg-purple-200 text-purple-800",
        Delivered: "bg-blue-200 text-blue-800",
        Pending: "bg-yellow-200 text-yellow-800",
        Closed: "bg-green-200 text-green-800",
      };
      return statusColors[status] || "";
    },
  },
};
</script>

<style>
/* Custom styling for enhanced UI */
</style>

