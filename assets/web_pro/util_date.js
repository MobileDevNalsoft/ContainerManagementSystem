window.getDaysDiff = function (dateString) {
  // 1. Convert the string to a Date object
  const givenDate = new Date(dateString);

  // 2. Get today's date
  const today = new Date('2025-02-18 14:35:05.062');

  // Important: Reset hours, minutes, seconds, and milliseconds to midnight for accurate day difference
  today.setHours(0, 0, 0, 0);
  const givenDateMidnight = new Date(givenDate);
  givenDateMidnight.setHours(0, 0, 0, 0);

  // 3. Calculate the difference in milliseconds
  const differenceInMs = today.getTime() - givenDateMidnight.getTime();

  // 4. Convert milliseconds to days
  const differenceInDays = Math.ceil(differenceInMs / (1000 * 60 * 60 * 24)); // Use Math.ceil to round up

  // 5. Display the result
  return differenceInDays-3;
};
