function isDuplicate(pageA, pageB) {
  if (!pageA || !pageB) {
    return false;
  }
  return pageA.title === pageB.title;
}
module.exports = { isDuplicate };
